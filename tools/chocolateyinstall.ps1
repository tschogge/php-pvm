
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

$currentSystemPath = [Environment]::GetEnvironmentVariable("Path", "Machine")
if ($currentSystemPath -notlike "*$targetPath*") {
    $newPath = $currentSystemPath + ";" + $targetPath
    [Environment]::SetEnvironmentVariable("Path", $newPath, "Machine")
    Write-Host "Added $targetPath to the system PATH"
} else {
    Write-Host "$targetPath is already in the system PATH"
}

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = 'EXE'
  softwareName  = '$toolName*'
  silentArgs    = "/S"
  validExitCodes= @(0)
  File          = "$toolsDir\$toolName.$fileType"
}

Install-ChocolateyPackage @packageArgs