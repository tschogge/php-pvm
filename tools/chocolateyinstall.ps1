
$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$packageName = "pvm"
$fileType = "exe"
$filePath = "$toolsDir/$packageName.$fileType"
$userDataPath = [Environment]::GetFolderPath('ApplicationData')
$targetPath = "$userDataPath\.$packageName\bin"


if (!(Test-Path $targetPath)) {
    New-Item -ItemType Directory -Path $targetPath -Force
    Write-Host "Created directory $targetPath"
}

Copy-Item -Path $filePath -Destination $targetPath -Force


$currentSystemPath = [Environment]::GetEnvironmentVariable("Path", "Machine")
if ($currentSystemPath -notlike "*$targetPath*") {
    $newPath = $currentSystemPath + ";" + $targetPath
    [Environment]::SetEnvironmentVariable("Path", $newPath, "Machine")
    Write-Host "Added $targetPath to the system PATH"
} else {
    Write-Host "$targetPath is already in the system PATH"
}

Write-Host "The binary has been installed to $targetPath"


$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = 'EXE'

  softwareName  = 'pvm*'
  url           = 'https://github.com/hjbdev/pvm/releases/download/1.2.0/pvm.exe'
  url64         = 'https://github.com/hjbdev/pvm/releases/download/1.2.0/pvm.exe'

  checksum      = '101AC193D9D40ECFC28964DC6C0090769AAB407C523FEF1105ADB83CB9C78B95E2C70771C42122DB87CF20D467FA40EA90A78B6E88B5F896A67D07356E6165F7'
  checksumType  = 'sha512'
  checksum64    = '101AC193D9D40ECFC28964DC6C0090769AAB407C523FEF1105ADB83CB9C78B95E2C70771C42122DB87CF20D467FA40EA90A78B6E88B5F896A67D07356E6165F7'
  checksumType64= 'sha512'

  silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs