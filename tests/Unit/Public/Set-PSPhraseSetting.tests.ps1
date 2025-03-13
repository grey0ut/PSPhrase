BeforeAll {
    Import-Module $ModuleName
}

Describe 'Set-PSPhraseSetting' {
    It 'Should return nothing' {
        $PassPhraseOutput = Set-PSPhraseSetting
        $PassPhraseOutput | Should -Be $null
    }

    It 'Should execute without error using -WhatIf' {
        try {
            Set-PSPhraseSetting -Count 1 -WhatIf -ErrorAction Stop
        } catch {
            $Fail = $_
        }
        $Fail | Should -BeNullOrEmpty
    }
}
