# tools/setup-local-env.ps1
# Automated setup for Spoken Arabic Dictionary local environment
# Requires Run as Administrator

# Ensure running as admin
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
  Write-Warning "Please run this script as Administrator. It needs to configure IIS."
  exit
}

$ProjectRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$AppDataPath = Join-Path $ProjectRoot "App_Data"
$SiteName = "MilonLocal"
$Port = 8081
$AppPoolName = "MilonAppPool"

Write-Host "Setting up Spoken Arabic Dictionary Local Environment..." -ForegroundColor Cyan

# 1. Create App_Data if it doesn't exist
if (-not (Test-Path $AppDataPath)) {
  Write-Host "Creating demo App_Data directory..." -ForegroundColor Yellow
  New-Item -ItemType Directory -Force -Path $AppDataPath | Out-Null
    
  # Create a demo txt file to indicate where the database goes
  $demoMessage = "Place the actual Access Database here, or clone it from the secure location."
  Set-Content -Path (Join-Path $AppDataPath "demo-database-placeholder.txt") -Value $demoMessage
  Write-Host "Created App_Data directory." -ForegroundColor Green
}
else {
  Write-Host "App_Data directory already exists." -ForegroundColor Green
}

# 2. Check IIS feature installation
Write-Host "Checking if IIS and ASP are installed..."
$iisFeature = Get-WindowsOptionalFeature -Online -FeatureName IIS-WebServerRole -ErrorAction SilentlyContinue
$aspFeature = Get-WindowsOptionalFeature -Online -FeatureName IIS-ASP -ErrorAction SilentlyContinue

if ($iisFeature -ne $null -and $iisFeature.State -ne 'Enabled' -or ($aspFeature -ne $null -and $aspFeature.State -ne 'Enabled')) {
  Write-Host "IIS or ASP is not installed. Attempting to enable..." -ForegroundColor Yellow
  Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServerRole, IIS-WebServer, IIS-CommonHttpFeatures, IIS-DefaultDocument, IIS-ISAPIExtensions, IIS-ISAPIFilter, IIS-ASP, IIS-StaticContent -All -NoRestart
  Write-Host "IIS installed successfully." -ForegroundColor Green
}
else {
  Write-Host "IIS and ASP are already enabled or checking failed (checking state requires exact SKU mapping, assuming OK if skipping)." -ForegroundColor Green
}

# 3. Check if IIS Service (W3SVC) is running
$w3svc = Get-Service -Name W3SVC -ErrorAction SilentlyContinue
if ($w3svc -eq $null) {
  Write-Host "World Wide Web Publishing Service (W3SVC) not found." -ForegroundColor Red
}
elseif ($w3svc.Status -ne "Running") {
  Write-Host "IIS is not running. Starting IIS..." -ForegroundColor Yellow
  Start-Service -Name W3SVC
  Write-Host "IIS started." -ForegroundColor Green
}
else {
  Write-Host "IIS is already running." -ForegroundColor Green
}

# Load WebAdministration module
Import-Module WebAdministration 

# 4. Create App Pool
if (-not (Test-Path "IIS:\AppPools\$AppPoolName")) {
  Write-Host "Creating Application Pool: $AppPoolName..." -ForegroundColor Yellow
  New-Item "IIS:\AppPools\$AppPoolName" | Out-Null
  # Frequently Classic ASP connects to 32 bit Access databases. Enabling 32-bit can save headaches.
  Set-ItemProperty "IIS:\AppPools\$AppPoolName" -Name "enable32BitAppOnWin64" -Value $true
  Write-Host "App Pool $AppPoolName created (32-bit enabled)." -ForegroundColor Green
}
else {
  Write-Host "App Pool $AppPoolName already exists." -ForegroundColor Green
}

# 5. Create IIS Site on port 8081
if (-not (Test-Path "IIS:\Sites\$SiteName")) {
  Write-Host "Creating IIS Site $SiteName on port $Port..." -ForegroundColor Yellow
  New-Item "IIS:\Sites\$SiteName" -bindings @{protocol = "http"; bindingInformation = "*:${Port}:" } -physicalPath $ProjectRoot | Out-Null
  Set-ItemProperty "IIS:\Sites\$SiteName" -Name applicationPool -Value $AppPoolName
  Write-Host "Site $SiteName created successfully." -ForegroundColor Green
}
else {
  Write-Host "Site $SiteName already exists. Verifying configuration..." -ForegroundColor Green
  Set-ItemProperty "IIS:\Sites\$SiteName" -Name physicalPath -Value $ProjectRoot
}

# 6. Set directory permissions for App_Data
Write-Host "Setting folder permissions for IIS_IUSRS on App_Data..." -ForegroundColor Yellow
$acl = Get-Acl $AppDataPath
$permission = "BUILTIN\IIS_IUSRS", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow"
$accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule $permission
$acl.SetAccessRule($accessRule)
Set-Acl $AppDataPath $acl
Write-Host "Permissions updated for IIS_IUSRS." -ForegroundColor Green

Write-Host "--------------------------------------------------------" -ForegroundColor Cyan
Write-Host "Setup Complete!" -ForegroundColor Green
Write-Host "You can now access the local site at: http://localhost:$Port" -ForegroundColor Cyan
Write-Host "Note: You will need the actual database file in the App_Data folder to load data." -ForegroundColor Yellow
