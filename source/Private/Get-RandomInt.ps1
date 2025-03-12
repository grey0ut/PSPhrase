Function Get-RandomInt {
    <#
    .SYNOPSIS
    More robust method of getting a random number than Get-Random
    .DESCRIPTION
    Leverages the .NET RNGCryptoServiceProvider to retrieve a random number
    .PARAMETER Minimum
    Minimum number for range of random number generation
    .PARAMETER Maximum
    Maximum number for range of random number generation
    .EXAMPLE
    PS> Get-RanomInt -Minimum 1 -Maximum 1000
    838

    will return a random number from between 1 and 1000
    #>
    param (
        [UInt32]$Minimum,
        [UInt32]$Maximum
    )

    $Difference = $Maximum-$Minimum+1
    [Byte[]]$Bytes = 1..4
    [System.Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($Bytes)
    [Int32]$Integer = [System.BitConverter]::ToUInt32(($Bytes),0) % $Difference + 1
    $Integer
}
