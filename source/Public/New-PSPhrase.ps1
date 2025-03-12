function New-PSPhrase {
    <#
    .SYNOPSIS
    Generate a passphrase
    .DESCRIPTION
    Creates a passphrase using adjective/noun pairs in the style of natural language.  These are robust, random, and significantly easier to remember than random gibberish.
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
    .PARAMETER IncludeNumber
    Switch parameter to randomly include a number within the passphrase
    .PARAMETER IncludeSymbol
    Switch parameter to randomly include a symbol within the passphrase
    #>
    [CmdletBinding()]
    param (
        [ValidateRange(1,100)] 
        [Int32]$Pairs = 2,
        [Switch]$TitleCase,
        [Switch]$Substitution,
        [String]$Append,
        [String]$Prepend,
        [String]$Delimiter = ' ',
        [ValidateRange(1,500)]
        [Int32]$Count = 1,
        [Switch]$IncludeNumber,
        [Switch]$IncludeSymbol
    )

    $Settings = [Ordered]@{
        Pairs = $Pairs
        Count = $Count
        Delimiter = $Delimiter
    }
    if ($DefaultSettings = Get-PSPhraseSettings) {
        foreach ($Setting in $DefaultSettings.PSObject.Properties.Name) {
            if (-not($PSBoundParameters.ContainsKey($Setting))) {
                $Settings.$Setting = $DefaultSettings.$Setting
            } 
        }
    }
    if ($TitleCase) {
        $Settings.Add("TitleCase",$true)
    }
    if ($Substitution) {
        $Settings.Add("Substitution",$true)
    }
    if ($IncludeNumber) {
        $Settings.Add("IncludeNumber",$true)
    }
    if ($IncludeSymbol) {
        $Settings.Add("IncludeSymbol",$true)
    }
    if ($Prepend) {
        $Settings.Add("Prepend",$Prepend)
    }
    if ($Append) {
        $Settings.Add("Append",$Append)
    }

    $NounsHash = Initialize-Dictionary -Type Nouns 
    $AdjectivesHash = Initialize-Dictionary -Type Adjectives

    $Passphrases = 1..$Settings.Count | ForEach-Object {
        [System.Collections.ArrayList]$WordArray = 1..$Settings.Pairs | ForEach-Object {
            $Number = Get-RandomInt -Minimum 1 -Maximum $AdjectivesHash.Count 
            $AdjectivesHash.$Number
            $Number = Get-RandomInt -Minimum 1 -Maximum $NounsHash.Count 
            $NounsHash.$Number
        }

        $CultureObj = (Get-Culture).TextInfo

        switch ($Settings.Keys) {
            'TitleCase' {
                $WordArray = $WordArray | ForEach-Object {
                    $CultureObj.ToTitleCase($_)
                }
            }
            'Substitution' {
                $WordArray = $WordArray -replace "e","3" -replace "a","@" -replace "o","0" -replace "s","$" -replace "i","1"
            }
            'IncludeNumber' {
                $RandomNumber = Get-Random -Minimum 0 -Maximum 9
                $WordIndex = $WordArray.IndexOf(($WordArray | Get-Random))
                $Position = 0,($WordArray[$WordIndex].Length) | Get-Random
                $WordArray[$WordIndex] = $WordArray[$WordIndex].Insert($Position, $RandomNumber)
            }
            'IncludeSymbol' {
                $RandomSymbol = '!', '@', '#', '$', '%', '*', '?' | Get-Random
                $WordIndex = $WordArray.IndexOf(($WordArray | Get-Random))
                $Position = 0,($WordArray[$WordIndex].Length) | Get-Random
                $WordArray[$WordIndex] = $WordArray[$WordIndex].Insert($Position, $RandomSymbol)
            }
            'Append' {
                [Void]$WordArray.Add($Settings.Append)
            }
            'Prepend' {
                $WordArray.Insert(0, $Settings.Prepend)
            }
        }
        $WordArray -join $Settings.Delimiter
    }
    $Passphrases
}
