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
}
