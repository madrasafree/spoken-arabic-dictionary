$files = Get-ChildItem admin\*.asp
foreach ($f in $files) {
  $content = [IO.File]::ReadAllText($f.FullName)
  $newContent = $content.Replace('file="../includes/', 'virtual="/includes/')
  [IO.File]::WriteAllText($f.FullName, $newContent)
  Write-Host "Updated $($f.Name)"
}
