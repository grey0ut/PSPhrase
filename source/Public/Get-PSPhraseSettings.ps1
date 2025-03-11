function Get-PSPhraseSettings {
    <#
    .SYNOPSIS
    returns a table of the settings currently being used with PSPhrase
    .DESCRIPTION
    returns the current settings being leverage as "defaults" with New-PSPhrase.  If custom settings have been specified with Set-PSPhraseSettings those will be returned
    #>
    [CmdletBinding()]
    param (
    # no parameters
    )
    
    # check to see if we're on Windows or not
    if ($IsWindows -or $ENV:OS) {
        $Windows = $true
    } else {
        $Windows = $false
    }
    if ($Windows) {
        $SettingsPath = Join-Path -Path $Env:APPDATA -ChildPath "PSPhrase" -AdditionalChildPath Settings.json
    } else {
        $SettingsPath = Join-Path -Path ([Environment]::GetEnvironmentVariable("HOME")) -ChildPath ".local" -AdditionalChildPath "share","powershell","Modules","PSPhrase",Settings.json
    }

    if (Test-Path $SettingsPath) {
        try {
            $Settings = Get-Content -Path $SettingsPath | ConvertFrom-Json -AsHashtable
        } catch {
            throw $_
        }
        $Settings
    } else {
        Write-Verbose "No saved settings found"
    }
}
