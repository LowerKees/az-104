. $PSScriptRoot/../_functions.ps1

#Requires -Modules @{ ModuleName="Az.Resources"; ModuleVersion="0.12.0" }

$RESOURCEGROUPNAME = "rg-dencrypt-104-001"
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

$vmUsername = "nimda001" | ConvertTo-SecureString -AsPlainText -Force
$vmPassword = New-VmPassword | ConvertTo-SecureString -AsPlainText -Force
$userObjectId = (Get-AzADUser -SignedIn).Id

$params = @{
    ResourceGroupName = $RESOURCEGROUPNAME
    Mode              = "Incremental"
    TemplateFile      = "$PSScriptRoot/main.bicep"
    vmUsername        = $vmUsername
    vmPassword        = $vmPassword
    userObjectId      = $userObjectId
}

New-AzResourceGroupDeployment @params