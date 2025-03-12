BeforeAll {
    Import-Module $ModuleName
}

Describe 'Get-PSPhraseSetting' {
    It 'Should not error' {
        try {
            $PassPhraseOutput = Get-PSPhraseSetting -ErrorAction Stop
            $Failed = $false
        } catch {
            $Failed = $true
        }
        $Failed | Should -Be $false
    }
}
