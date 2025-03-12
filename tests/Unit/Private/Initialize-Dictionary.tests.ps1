BeforeAll {
    Import-Module $ModuleName
}

Describe 'Initialize-Dictionary' {
    It 'Should return dictionary of nouns' {
        InModuleScope $ModuleName {
            $Nouns = Initialize-Dictionary -Type Nouns
            $Nouns.GetType().Name | Should -Be 'OrderedDictionary'
            $Nouns.Count | Should -BeGreaterOrEqual 1000 -Because 'There are more than 1000 words in the Nouns.txt file'
        }
    }
    It 'Should return dictionary of adjectives' {
        InModuleScope $ModuleName {
            $Adjectives = Initialize-Dictionary -Type Adjectives
            $Adjectives.GetType().Name | Should -Be 'OrderedDictionary'
            $Adjectives.Count | Should -BeGreaterOrEqual 1000 -Because 'There are more than 1000 words in the Adjectives.txt file'
        }
    }
}
