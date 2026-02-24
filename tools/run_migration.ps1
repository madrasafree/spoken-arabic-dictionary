$admin_files = @(
    "admin.allowEditToggle.asp",
    "admin.asp",
    "admin.labelControl.asp",
    "admin.labelNew.insert.asp",
    "admin.locked.asp",
    "admin.readOnlyToggle.asp",
    "admin.userControl.asp",
    "admin.userControl.full.asp",
    "admin.userEdit.asp",
    "admin.userEdit.update.asp",
    "admin.userNew.asp",
    "admin.userNew.insert.asp",
    "admin.wordsShort.asp"
)

md -Force admin

foreach ($file in $admin_files) {
    if (Test-Path $file) {
        $content = Get-Content $file -Raw -Encoding UTF8
        
        $content = $content -replace '"includes/inc.asp"', '"../includes/inc.asp"'
        $content = $content -replace '"assets/', '"../assets/'
        
        $content = $content -replace '"login.asp"', '"../login.asp"'
        $content = $content -replace 'href="login.asp"', 'href="../login.asp"'
        $content = $content -replace 'Response.Redirect "login.asp"', 'Response.Redirect "../login.asp"'

        $rootLinks = @("word.edit.asp", "word.asp", "words.asp", "sentence.asp", "sentences.asp", "label.asp", "labels.asp", "dashboard.asp", "tools/", "team/", "profile.asp")
        foreach ($l in $rootLinks) {
            $content = $content -replace '"' + $l + '"', '"../' + $l + '"'
            $content = $content -replace '=' + $l, '=../' + $l
        }

        $content = $content -replace 'admin.asp', 'index.asp'
        $content = $content -replace 'admin.userControl.asp', 'userControl.asp'
        $content = $content -replace 'admin.userControl.full.asp', 'userControl.full.asp'
        $content = $content -replace 'admin.userEdit.asp', 'userEdit.asp'
        $content = $content -replace 'admin.userEdit.update.asp', 'userEdit.update.asp'
        $content = $content -replace 'admin.userNew.asp', 'userNew.asp'
        $content = $content -replace 'admin.userNew.insert.asp', 'userNew.insert.asp'
        $content = $content -replace 'admin.wordsShort.asp', 'wordsShort.asp'
        $content = $content -replace 'admin.readOnlyToggle.asp', 'readOnlyToggle.asp'
        $content = $content -replace 'admin.locked.asp', 'locked.asp'
        $content = $content -replace 'admin.allowEditToggle.asp', 'allowEditToggle.asp'
        $content = $content -replace 'admin.labelControl.asp', 'labelControl.asp'
        $content = $content -replace 'admin.labelNew.insert.asp', 'labelNew.insert.asp'

        $newName = $file -replace 'admin.', ''
        if ($newName -eq 'asp') { $newName = 'index.asp' }

        $content | Set-Content "admin\$newName" -Encoding UTF8
        Write-Host "Created admin\$newName"

        $redirect = "<%@ Language=VBScript %>`n<%`nDim qs`nqs = Request.ServerVariables(""QUERY_STRING"")`nIf qs <> """" Then`n    qs = ""?"" & qs`nEnd If`nResponse.Status=""301 Moved Permanently""`nResponse.AddHeader ""Location"", ""admin/$newName"" & qs`nResponse.End`n%>"
        $redirect | Set-Content $file -Encoding UTF8
    }
}

$otherFiles = Get-ChildItem -Filter *.asp | Where-Object { $_.Name -notin $admin_files }
$otherFiles += Get-ChildItem team/*.asp

foreach ($f in $otherFiles) {
    if (Test-Path $f.FullName) {
        $content = Get-Content $f.FullName -Raw -Encoding UTF8
        $orig = $content
        
        $content = $content -replace 'admin.asp', 'admin/'
        $content = $content -replace 'admin.userControl.asp', 'admin/userControl.asp'
        $content = $content -replace 'admin.userControl.full.asp', 'admin/userControl.full.asp'
        $content = $content -replace 'admin.userEdit.asp', 'admin/userEdit.asp'
        $content = $content -replace 'admin.userEdit.update.asp', 'admin/userEdit.update.asp'
        $content = $content -replace 'admin.userNew.asp', 'admin/userNew.asp'
        $content = $content -replace 'admin.userNew.insert.asp', 'admin/userNew.insert.asp'
        $content = $content -replace 'admin.wordsShort.asp', 'admin/wordsShort.asp'
        $content = $content -replace 'admin.readOnlyToggle.asp', 'admin/readOnlyToggle.asp'
        $content = $content -replace 'admin.locked.asp', 'admin/locked.asp'
        $content = $content -replace 'admin.allowEditToggle.asp', 'admin/allowEditToggle.asp'
        $content = $content -replace 'admin.labelControl.asp', 'admin/labelControl.asp'
        $content = $content -replace 'admin.labelNew.insert.asp', 'admin/labelNew.insert.asp'
        
        if ($content -cne $orig) {
            $content | Set-Content $f.FullName -Encoding UTF8
            Write-Host "Updated $($f.Name)"
        }
    }
}

Write-Host "Migration script completed."
