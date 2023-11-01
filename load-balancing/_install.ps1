. $PSScriptRoot/_functions.ps1

#Requires -Modules Az.Resources


$RESOURCEGROUPNAME = "rg-lb-104-001"
$TAGS = @{
    "Project"        = "104"
    "Delete"         = "Yes"
    "DeletionPolicy" = "Overnight"
}

$params = @{
    Name        = $RESOURCEGROUPNAME
    Location    = "Germany West Central"
    ErrorAction = "SilentlyContinue"
    Tag         = $TAGS
}

if (!(Get-AzResourceGroup @params)) { New-AzResourceGroup @params }

$vmUsernames = @{"vm1" = "nimda001"; "vm2" = "nimda002" }
$vmPasswords = @{"vm1" = (New-VmPassword); "vm2" = (New-VmPassword) }
$userObjectId = (Get-AzADUser -SignedIn).Id

$params = @{
    ResourceGroupName = $RESOURCEGROUPNAME
    Mode              = "Incremental"
    TemplateFile      = "$PSScriptRoot/main.bicep"
    vmUsernames       = $vmUsernames
    vmPasswords       = $vmPasswords
    userObjectId      = $userObjectId
}

New-AzResourceGroupDeployment @params 