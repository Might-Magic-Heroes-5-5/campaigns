$game_dirs = @(
  "UserMODs\MMH55-Cam-Maps",
  "UserMODs\MMH55-Cam-Texts-EN",
  "UserMODs\MMH55-SPMaps",
  "UserMODs\MMH55-SPMaps-Texts-EN"
)

$base   = if ($PSScriptRoot) { $PSScriptRoot } else { (Get-Location).Path }
$outDir = Join-Path $base 'output'
New-Item -ItemType Directory -Path $outDir -Force | Out-Null

$sevenZip = $null
$cmd = Get-Command 7z.exe -ErrorAction SilentlyContinue
if ($cmd) { $sevenZip = $cmd.Path }
if (-not $sevenZip) {
  $candidates = @(
    'C:\Program Files\7-Zip\7z.exe',
    'C:\Program Files (x86)\7-Zip\7z.exe'
  )
  foreach ($c in $candidates) {
    if (Test-Path $c) { $sevenZip = $c; break }
  }
}
if (-not $sevenZip) {
  throw "7z.exe not found. Add it to PATH or install 7-Zip (standard path) and retry."
}

$utf16leBom = New-Object System.Text.UnicodeEncoding($false, $true) # LE, BOM

foreach ($name in $game_dirs) {
  $dir = Join-Path $base $name
  if (-not (Test-Path -LiteralPath $dir)) {
    Write-Output "Skip: $name (not found)"
    continue
  }

  Write-Output "Converting *.txt in $name to UTF-16 LE BOM (preserving timestamps)..."
  Get-ChildItem -LiteralPath $dir -Recurse -File -Filter '*.txt' | ForEach-Object {
    $fi = Get-Item -LiteralPath $_.FullName
    $origRO   = $fi.IsReadOnly
    $origCT   = $fi.CreationTime
    $origLAT  = $fi.LastAccessTime
    $origLWT  = $fi.LastWriteTime

    if ($origRO) { $fi.IsReadOnly = $false }

    $reader  = [System.IO.StreamReader]::new($fi.FullName, $true)
    $content = $reader.ReadToEnd()
    $reader.Close()

    [System.IO.File]::WriteAllText($fi.FullName, $content, $utf16leBom)

    # Restore timestamps (and read-only if it was set)
    $fi = Get-Item -LiteralPath $fi.FullName
    $fi.CreationTime   = $origCT
    $fi.LastAccessTime = $origLAT
    $fi.LastWriteTime  = $origLWT
    if ($origRO) { $fi.IsReadOnly = $true }
  }
  
 
  $zipPath = Join-Path $outDir ($name + '.zip')
  $pakPath = Join-Path $outDir ($name + '.h5u')

  if (Test-Path -LiteralPath $zipPath) { Remove-Item -LiteralPath $zipPath -Force }
  if (Test-Path -LiteralPath $pakPath) { Remove-Item -LiteralPath $pakPath -Force }

  Write-Output "Packing $name with 7-Zip (ZIP/Deflate level 5, mfb=32)..."
  & $sevenZip a `
    -tzip `
    -mx=5 `
    -mm=Deflate `
    -mfb=32 `
    -y `
    $zipPath `
    "$dir\*" | Out-Null

  Move-Item -LiteralPath "$zipPath" -Destination "$pakPath" -Force
  Write-Output "Created: $pakPath"
}
Write-Output "All done."
