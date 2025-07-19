Import-Module Chocolatey-AU

function global:au_GetLatest {
    $latestRelease = Invoke-RestMethod -UseBasicParsing -Uri "https://api.github.com/repos/hjbdev/pvm/releases/latest"
    
    @{
        URL64        = $latestRelease.assets.browser_download_url
        Version      = $latestRelease.tag_name
        ReleaseNotes = $latestRelease.body
    }
}

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(?i)(^\s*(\$)url64\s*=\s*)('.*')"      = "`$1'$($Latest.URL64)'"
            "(?i)(^\s*checksum64\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum64)'"
            "(?i)(^\s*checksumType64\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType64)'"
        }

        "php-pvm.nuspec"                = @{
            "(\<releaseNotes\>).*?(\</releaseNotes\>)" = "`$1$($Latest.ReleaseNotes)`$2"
            "(\<version\>).*?(\</version\>)"           = "`$1$($Latest.Version)`$2"
        }

    }
}
