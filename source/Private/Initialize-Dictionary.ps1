function Initialize-Dictionary {
    <#
    .SYNOPSIS
    Creates ordered hashtables of wordlists for faster retrieval with random number generator
    .DESCRIPTION
    Reads in a text file containing one word per line and creates an ordered dictionary starting the keys with '1' and incrementing up from there
    for each word added.  Then using a RNG a corresponding key can be called and the associated value (word) can be retrieved very quickly
    .PARAMETER Type
    Whether to load the Nouns or Adjectives list
    .EXAMPLE
    $Nouns = Initialize-Dictionary -Type Nouns

    will turn $Nouns in to a hashtable containing all the words from the Nouns.txt file
    #>
    [Cmdletbinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
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
