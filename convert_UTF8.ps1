$directory = Join-Path -Path $PSScriptRoot -ChildPath "UserMODs"
Write-Output "Processing directory..."

# - UTF-8 BOM is used by this repository so github can show diff during PRs
$targetEncoding = New-Object System.Text.UTF8Encoding($true) # UTF-8 with BOM

Get-ChildItem -Path $directory -Recurse -Filter "*.bak" | Remove-Item -Force

Get-ChildItem -Path $directory -Recurse -File | Where-Object {
    $_.Extension -in '.txt'
  } | ForEach-Object {
    $fi = Get-Item -LiteralPath $_.FullName
    $origRO  = $fi.IsReadOnly
    $origCT  = $fi.CreationTime
    $origLAT = $fi.LastAccessTime
    $origLWT = $fi.LastWriteTime

    if ($origRO) { $fi.IsReadOnly = $false }

    $reader  = [System.IO.StreamReader]::new($fi.FullName, $true) # detect BOM/encoding
    $content = $reader.ReadToEnd()
    $reader.Close()

    [System.IO.File]::WriteAllText($fi.FullName, $content, $targetEncoding)

    $fi = Get-Item -LiteralPath $fi.FullName
    $fi.CreationTime   = $origCT
    $fi.LastAccessTime = $origLAT
    $fi.LastWriteTime  = $origLWT
    if ($origRO) { $fi.IsReadOnly = $true }
  }
Write-Output "Conversion complete!"
