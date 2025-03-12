BeforeDiscovery {
    $projectPath = "$($PSScriptRoot)\..\.." | Convert-Path

    <#
        If the QA tests are run outside of the build script (e.g with Invoke-Pester)
        the parent scope has not set the variable $ProjectName.
    #>
    if (-not $ProjectName)
    {
        # Assuming project folder name is project name.
        $ProjectName = Get-SamplerProjectName -BuildRoot $projectPath
    }

    $script:moduleName = $ProjectName

    Remove-Module -Name $script:moduleName -Force -ErrorAction SilentlyContinue

    $mut = Get-Module -Name $script:moduleName -ListAvailable |
        Select-Object -First 1 |
            Import-Module -Force -ErrorAction Stop -PassThru
}

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
