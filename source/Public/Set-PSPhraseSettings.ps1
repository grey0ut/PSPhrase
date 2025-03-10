function Set-PSPhraseSettings {
    <#
    .SYNOPSIS
    Configures the parameter defaults for New-PSPhrase by saving the settings to a file
    .DESCRIPTION
    Default parameter values for New-PSPhrase are retrieved via Get-PSPhraseSettings.  To reduce the amount of parameters you have to pass to New-PSPhrase you can set your preferences
    with Set-PSPhraseSettings and they will be saved to a file for retrieval by Get-PSPhraseSettings by default later
    
    #>
    [CmdletBinding()]
    param (
        [ValidateRange(1,10)] 
        [Int32]$Pairs = 2,
        [Switch]$TitleCase,
        [Switch]$Substitution,
        [String]$Append,
        [String]$Prepend,
        [String]$Delimiter = ' ',
        [ValidateRange(1,500)]
        [Int32]$Count = 1,
        [Switch]$IncludeNumber,
        [Switch]$IncludeSymbol,
        [Switch]$Defaults
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

    $Settings = [Ordered]@{}

    if (-not($Defaults)) {
        switch ($PSBoundParameters.Keys) {
            'Pairs' {
                $Settings.Pairs = $Pairs
            }
            'TitleCase' {
                $Settings.TitleCase = $true
            }
            'Substitution' {
                $Settings.Substitution = $true
            }
            'Append' {
                $Settings.Append = $Append
            }
            'Prepend' {
                $Settings.Prepend = $Prepend
            }
            'Delimiter' {
                $Settings.Delimiter = $Delimiter
            }
            'Count' {
                $Settings.Count = $Count
            }
            'IncludeNumber' {
                $Settings.IncludeNumber = $true
            }
            'IncludeSymbol' {
                $Settings.IncludeSymbol = $true
            }
        }
    Write-Verbose "Saving settings to $($SettingsPath)"
    try {
        if (Test-Path $SettingsPath) {
            $Settings | ConvertTo-Json | Out-File -Path $SettingsPath -Force
            } else {
                New-Item -Path $SettingsPath -Force | Out-Null
                $Settings | ConvertTo-Json | Out-File -Path $SettingsPath
            }
    } catch {
        throw $_
        }
    } else {
        try {
            Write-Verbose "Removing settings file at $($SettingsPath)"
            Remove-Item -Path $SettingsPath -Force -ErrorAction Stop
        } catch [System.Management.Automation.ItemNotFoundException] {
            Write-Warning "No settings file found"
        } catch {
            throw $_
        }
    }
}
