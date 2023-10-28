function New-VmPassword {
    $vmPassword = ""
    foreach ($i in 1..32) {
        $vmPassword += [char[]](30..47 + 41..80 + 123..126 | Get-Random -Count 1)
    }
    return $vmPassword
}