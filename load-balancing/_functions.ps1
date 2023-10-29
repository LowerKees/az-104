function New-VmPassword {
    $vmPassword = ""
    foreach ($i in 1..32) {
        $vmPassword += [char[]](33..47 + 41..80 + 97..122 + 123..126 | Get-Random -Count 1)
    }
    return $vmPassword
}