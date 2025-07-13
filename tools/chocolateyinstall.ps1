
$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$packageName = "php-pvm"
$toolName = "pvm"
$fileType = "exe"
$userDataPath = [Environment]::GetFolderPath('UserProfile')
$targetPath = "$userDataPath\.$toolName\bin"


if (!(Test-Path $targetPath)) {
    New-Item -ItemType Directory -Path $targetPath -Force
    Write-Host "Created directory $targetPath"
}

Install-ChocolateyPath $targetPath "Machine"
Write-Host "Added $targetPath to the system PATH"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = 'EXE'
  softwareName  = '$toolName*'
  silentArgs    = "/S"
  validExitCodes= @(0)
  File          = "$toolsDir\$toolName.$fileType"
}

Install-ChocolateyPackage @packageArgs