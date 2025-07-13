$ErrorActionPreference = 'Stop'
$packageName = "php-pvm"
$toolName = "pvm"
$userDataPath = [Environment]::GetFolderPath('UserProfile')
$targetPath = "$userDataPath\.$toolName"

if (Test-Path $targetPath) {
    Remove-Item $targetPath -Force -Recurse
    Write-Host "Removed the directory and all its contents from $targetPath"
}

Uninstall-ChocolateyPath $targetPath
Write-Host "Removed $targetPath from the system PATH"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = '$toolName*'
  fileType      = 'EXE'
  silentArgs    = "/qn /norestart"
  validExitCodes= @(0, 3010, 1605, 1614, 1641)
}

[array]$key = Get-UninstallRegistryKey -SoftwareName $packageArgs['softwareName']

if ($key.Count -eq 1) {
  $key | % {
    $packageArgs['file'] = "$($_.UninstallString)"

    if ($packageArgs['fileType'] -eq 'MSI') {
      $packageArgs['silentArgs'] = "$($_.PSChildName) $($packageArgs['silentArgs'])"

      $packageArgs['file'] = ''
    } else {
    }

    Uninstall-ChocolateyPackage @packageArgs
  }
} elseif ($key.Count -eq 0) {
  Write-Warning "$packageName has already been uninstalled by other means."
} elseif ($key.Count -gt 1) {
  Write-Warning "$($key.Count) matches found!"
  Write-Warning "To prevent accidental data loss, no programs will be uninstalled."
  Write-Warning "Please alert package maintainer the following keys were matched:"
  $key | % {Write-Warning "- $($_.DisplayName)"}
}