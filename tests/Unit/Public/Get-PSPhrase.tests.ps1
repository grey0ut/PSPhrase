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
    # Convert-Path required for PS7 or Join-Path fails
    $projectPath = "$($PSScriptRoot)\..\.." | Convert-Path
    # Get git-related project path. This is relevant for modules that will not be deployed in the root folder of Git.
    $gitTopLevelPath = (&git rev-parse --show-toplevel)
    $gitRelatedModulePath = (($projectPath -replace [regex]::Escape([IO.Path]::DirectorySeparatorChar), '/') -replace $gitTopLevelPath, '')
    if (-not [string]::IsNullOrEmpty($gitRelatedModulePath)) { $gitRelatedModulePath = $gitRelatedModulePath.Trim('/')  + '/' }
    $escapedGitRelatedModulePath = [regex]::Escape($gitRelatedModulePath)

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

    $sourcePath = (
        Get-ChildItem -Path $projectPath\*\*.psd1 |
            Where-Object -FilterScript {
                ($_.Directory.Name -match 'source|src' -or $_.Directory.Name -eq $_.BaseName) `
                    -and $(
                    try
                    {
                        Test-ModuleManifest -Path $_.FullName -ErrorAction Stop
                    }
                    catch
                    {
                        $false
                    }
                )
            }
    ).Directory.FullName
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
