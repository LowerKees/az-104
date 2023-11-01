function New-RandomString {
    $vmPassword = ""
    foreach ($i in 1..32) {
        $numerics = [char[]](48..57 | Get-Random -Count 5)
        $specials = [char[]](33..43 | Get-Random -Count 3)
        $upperCase = [char[]](65..90 | Get-Random -Count 12)
        $lowerCase = [char[]](97..122 | Get-Random -Count 12)
        $vmPassword = ($numerics + $specials + $upperCase + $lowerCase) -Join ""
        return $vmPassword
    }
}

function New-ShuffledString {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $InputString
    )

    $shuffledString = [System.Collections.ArrayList]::new()
    $inputList = [System.Collections.ArrayList]::new()
    foreach ($char in $InputString.ToCharArray()) {
        $inputList.Add($char) | Out-Null
    }

    while ($inputList.count -gt 0) {
        $char = $inputList | Get-Random -Count 1
        $shuffledString.Add($char) | Out-Null
        $inputList.Remove($char)
    }

    return ($shuffledString -Join "")
}

function New-VmPassword {
    $randomString = New-RandomString
    $vmPassword = New-ShuffledString -InputString $randomString
    return $vmPassword
}