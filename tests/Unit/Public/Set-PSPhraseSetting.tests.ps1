BeforeAll {
    Import-Module $ModuleName
}

Describe 'Set-PSPhraseSetting' {
    It 'Should return nothing' {
        $PassPhraseOutput = Set-PSPhraseSetting
        $PassPhraseOutput | Should -Be $null
    }
}
