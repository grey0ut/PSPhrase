BeforeAll {
    Import-Module $ModuleName
}

Describe 'Get-RandomInt' {
    It 'Should return integer' {
        InModuleScope $ModuleName {
            $RandomInt = Get-RandomInt -Minimum 1 -Maximum 10
            $RandomInt.GetType().Name | Should -Be 'Int32'
        }
    }
}
