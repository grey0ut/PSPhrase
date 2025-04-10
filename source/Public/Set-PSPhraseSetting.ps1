function Set-PSPhraseSetting {
    <#
    .SYNOPSIS
    Configures the parameter defaults for New-PSPhrase by saving the settings to a file
    .DESCRIPTION
    Default parameter values for New-PSPhrase are retrieved via Get-PSPhraseSettings.  To reduce the amount of parameters you have to pass to New-PSPhrase you can set your preferences
    with Set-PSPhraseSettings and they will be saved to a file for retrieval by Get-PSPhraseSettings by default later.  This was created as a more accessible way to achieve default
    parameter values without using $PSDefaultParameterValues and the $Profile
    .PARAMETER Pairs
    It generates Adjective/Noun pairs, this defines how many pairs you want returned. The default is 2 pair (two words)
    .PARAMETER TitleCase
    Switch parameter to toggle the use of title case. E.g. The First Letter Of Every Word Is Uppercase.
    .PARAMETER Substitution
    Switch parameter to toggle common character substitution.  E.g. '3's for 'e's and '@'s for 'a's etc.
    .PARAMETER Prepend
    Provide a string you would like prepended to the password output
    .PARAMETER Append
    Provide a string you would like appended to the password output
    .PARAMETER Delimiter
    This parameter accepts any string you would prefer as a delimiter between words. Defaults to a space.
    .PARAMETER Count
    The number of passphrases to be generated. Default is 1
    .PARAMETER IncludeNumber
    Switch parameter to randomly include a number within the passphrase
    .PARAMETER IncludeSymbol
    Switch parameter to randomly include a symbol within the passphrase
    .PARAMETER Defaults
    Reverts settings to default state by deleting the saved settings file and allowing New-PSPhrase to use default parameter values
    .EXAMPLE
    PS> Set-PSPhraseSetting -Count 10 -TitleCase -Delimiter '-' -Verbose
    VERBOSE: Saving settings to C:\Users\ContosoAdmin\AppData\Roaming\PSPhrase\Settings.json

    this will save the preferred parameter/values for use with Get-PSPhrase to a file at the described location
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [ValidateRange(1,10)]
        [Int32]$Pairs,
        [Switch]$TitleCase,
        [Switch]$Substitution,
        [String]$Append,
        [String]$Prepend,
        [String]$Delimiter,
        [ValidateRange(1,500)]
        [Int32]$Count,
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
        $SettingsPath = Join-Path -Path $Env:APPDATA -ChildPath "PSPhrase\Settings.json"
    } else {
        $SettingsPath = Join-Path -Path ([Environment]::GetEnvironmentVariable("HOME")) -ChildPath ".local/share/powershell/Modules/PSPhrase/Settings.json"
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
        # move these out of the switch statement to insure they don't manipulated by other rules
        if ($Append) {
            $Settings.Append = $Append
        }
        if ($Prepend) {
            $Settings.Prepend = $Prepend
        }
            if ($Settings.Count -gt 0) {
                try {
                    if (Test-Path $SettingsPath) {
                        Write-Verbose "Saving settings to $($SettingsPath)"
                        $Settings | ConvertTo-Json | Out-File -FilePath $SettingsPath -Force
                        } else {
                            Write-Verbose "Saving settings to $($SettingsPath)"
                            New-Item -Path $SettingsPath -Force | Out-Null
                            $Settings | ConvertTo-Json | Out-File -FilePath $SettingsPath
                        }
                } catch {
                    throw $_
                    }
            } else {
                Write-Warning "No settings specified. Nothing saved"
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
