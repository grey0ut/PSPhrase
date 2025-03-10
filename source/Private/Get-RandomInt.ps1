Function Get-RandomInt {
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
