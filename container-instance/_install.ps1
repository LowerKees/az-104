$RESOURCEGROUPNAME = "rg-aci-104-001"
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

$params = @{
    Name              = "aci-deploy"
    Location          = "Germany West Central"
    ResourceGroupName = $RESOURCEGROUPNAME
    Mode              = "Incremental"
    TemplateFile      = "$PSScriptRoot/main.bicep"
}

New-AzResourceGroupDeployment @params
