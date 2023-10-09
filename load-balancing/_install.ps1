$RESOURCEGROUPNAME = "rg-lb-104-001"

$params = @{
    Name        = $RESOURCEGROUPNAME
    Location    = "westeurope"
    ErrorAction = "SilentlyContinue"
}

if (!(Get-AzResourceGroup @params)) { New-AzResourceGroup @params }

$params = @{
    ResourceGroupName = $RESOURCEGROUPNAME
    Mode              = "Incremental"
    TemplateFile      = "$PSScriptRoot/main.bicep"
}

New-AzResourceGroupDeployment @params