BeforeAll {
    Import-Module $ModuleName
}

Describe 'Get-PSPhrase' {
    It 'Should return a string' {
        $PassPhraseOutput = Get-PSPhrase
        if ($PassPhraseOutput.Count -gt 1) {
            $PassPhraseOutput[0].GetType().Name | Should -Be 'String'
        } else {
            $PassPhraseOutput.GetType().Name | Should -Be 'String'
        }
        $PassPhraseOutput | Should -Not -BeNullOrEmpty
    }

    It 'Should return an array of strings' {
        $PassPhraseOutput = Get-PSPhrase -Count 5
        $PassPhraseOutput.GetType().Name | Should -Be 'Object[]' -Because '-Count was 5'
        $PassPhraseOutput[0].GetType().Name | Should -Be 'String'
    }

    It 'Should return unique passphrases without duplicate' {
        $PassPhraseOutput = Get-PSPhrase -Count 50
        $Unique = $PassPhraseOutput | Sort-Object -Unique | Measure-Object
        $Unique.Count | Should -Be '50' -Because '-Count of 50 was specified. Should return 50 unique passphrases'
    }

    It 'Should use default settings if present' {
        Set-PSPhraseSetting -Count 17 -Pairs 1 -IncludeNumber
        $PassPhraseOutput = Get-PSPhrase
        $PassPhraseOutput.Count | Should -Be '17' -Because 'Should be 17 passphrases because efault settings configured for 17 returned passphrases'
        $PassPhraseOutput[0] -Match '\d' | Should -BeTrue 'Should contain a number because -IncludeNumber was set by default settings'
        Set-PSPhraseSetting -Defaults
    }

    It 'Should use all settings if saved as defaults' {
        $SettingsSplat = @{
            Count = 1
            Pairs = 1
            Delimiter = '-'
            TitleCase = $true
            Substitution = $true
            IncludeNumber = $true
            IncludeSymbol = $true
            Prepend = 'START'
            Append = 'END'
        }
        Set-PSPhraseSetting @SettingsSplat
        $PassPhraseOutput = Get-PSPhrase
        $PassPhraseOutput.Count | Should -Be 1 -Because 'Default was set to 1 passphrase'
        $PassPhraseOutput  | Should -Match '^START'
        $PassPhraseOutput | Should -Match 'END$' 
        Set-PSPhraseSetting -Defaults    
    }

    It 'Should function if all parameters are used' {
        $SettingsSplat = @{
            Count = 1
            Pairs = 1
            Delimiter = '-'
            TitleCase = $true
            Substitution = $true
            IncludeNumber = $true
            IncludeSymbol = $true
            Prepend = 'START'
            Append = 'END'
        }
        $PassPhraseOutput = Get-PSPhrase @SettingsSplat
        $PassPhraseOutput | Should -Not -BeNullOrEmpty
        $PassPhraseOutput.Count | Should -Be 1 -Because 'Default was set to 1 passphrase'
        $PassPhraseOutput  | Should -Match '^START'
        $PassPhraseOutput | Should -Match 'END$' 
    }
}
