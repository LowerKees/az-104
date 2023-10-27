$RESOURCEGROUPNAME = "rg-lb-104-001"

$params = @{
    Name        = $RESOURCEGROUPNAME
    Location    = "Germany West Central"
    ErrorAction = "SilentlyContinue"
    Tag         = @{
        "Project"        = "104"
        "Delete"         = "Yes"
        "DeletionPolicy" = "Overnight"
    }
}

if (!(Get-AzResourceGroup @params)) { New-AzResourceGroup @params }

$params = @{
    ResourceGroupName = $RESOURCEGROUPNAME
    Mode              = "Incremental"
    TemplateFile      = "$PSScriptRoot/main.bicep"
}

New-AzResourceGroupDeployment @params