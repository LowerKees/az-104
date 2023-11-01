$RESOURCEGROUPNAME = "rg-acr-104-001"

$params = @{
    Name        = $RESOURCEGROUPNAME
    Location    = "Germany West Central"
    ErrorAction = "SilentlyContinue"
}

if (!(Get-AzResourceGroup @params)) {
    New-AzResourceGroup -Tag @{
        "Project"        = "104"
        "Delete"         = "Yes"
        "DeletionPolicy" = "Overnight"
    } @params
}

$params = @{
    ResourceGroupName = $RESOURCEGROUPNAME
    Mode              = "Incremental"
    TemplateFile      = "$PSScriptRoot/main.bicep"
}

New-AzResourceGroupDeployment @params