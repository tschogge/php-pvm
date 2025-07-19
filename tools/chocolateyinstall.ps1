
$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$toolName = "pvm"
$userDataPath = [Environment]::GetFolderPath('UserProfile')
$targetPath = "$userDataPath\.$toolName\bin"
$url64 = "https://github.com/hjbdev/pvm/releases/download/1.2.0/pvm.exe"
$checksum64 = "A764F8C2EE58EE4A5B026EEEDEFC044F1C4E3802CA96E4E8D00AF3E6504E831F"


if (!(Test-Path $targetPath)) {
  New-Item -ItemType Directory -Path $targetPath -Force
  Write-Host "Created directory $targetPath"
}

Install-ChocolateyPath $targetPath "Machine"
Write-Host "Added $targetPath to the system PATH"

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  fileType       = 'EXE'
  url64bit       = $url64
  softwareName   = "$toolName*"
  checksum64     = $checksum64
  checksumType64 = 'sha256'
  silentArgs     = "/S"
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs