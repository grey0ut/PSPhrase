function Get-PSPhraseSetting {
    <#
    .SYNOPSIS
    returns a table of the settings currently being used with PSPhrase
    .DESCRIPTION
    returns the current settings being leverage as "defaults" with New-PSPhrase.  If custom settings have been specified with Set-PSPhraseSettings those will be returned
    .EXAMPLE
    PS> Get-PSPhraseSetting


    if no settings have been saved via Set-PSPhraseSetting this will return nothing
    .EXAMPLE
    PS> Get-PSPhrasesetting
    Count TitleCase
    ----- ---------
    10      True

    if settings have been saved this will return them as a PSCustomObject with the properties/values corresponding to parameters for use with Get-PSPhrase
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
        $SettingsPath = Join-Path -Path $Env:APPDATA -ChildPath "PSPhrase\Settings.json"
    } else {
        $SettingsPath = Join-Path -Path ([Environment]::GetEnvironmentVariable("HOME")) -ChildPath ".local/share/powershell/Modules/PSPhrase/Settings.json"
    }

    if (Test-Path $SettingsPath) {
        try {
            $Settings = Get-Content -Path $SettingsPath | ConvertFrom-Json
        } catch {
            throw $_
        }
        $Settings
    } else {
        Write-Verbose "No saved settings found"
    }
}
