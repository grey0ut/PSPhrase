function Initialize-Dictionary {
    [Cmdletbinding()]
    param (
        [ValidateSet("Nouns","Adjectives")]
        [String]$Type
    )

    $File = switch ($Type) {
        "Nouns" {"Nouns.txt"}
        "Adjectives" {"Adjectives.txt"}
    }

    $WordListPath = Join-Path -Path ($PSScriptRoot) -ChildPath "Data/$File"

    #$Words = Get-Content -Path $WordListPath
    $Words = [System.IO.File]::ReadAllLines($WordListPath)
    $Dictionary = [Ordered]@{}
    $Number = 1
    foreach ($Word in $Words) {
        $Dictionary.Add($Number, $Word)
        $Number++
    }
    $Dictionary
}
