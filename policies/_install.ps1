[CmdletBinding()]
param (
    [Parameter(HelpMessage = "Subscription to add to the management group")]
    [string]
    $SubscriptionId = "82938184-2f4f-4956-82f5-50eb15f40d3a"
)
$params = @{
    GroupName   = "Managed";
    DisplayName = "Managed by custom policies";
    ErrorAction = "SilentlyContinue";
}
$mgtGroup = New-AzManagementGroup @params

$params = @{
    GroupId        = $mgtGroup.Id;
    SubscriptionId = $SubscriptionId;
    ErrorAction    = "SilentlyContinue";
}
New-AzManagementGroupSubscription @params

$RESOURCEGROUPNAME = "rg-poli-104-001"
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
    Name              = "policy-deploy"
    Location          = "Germany West Central"
    ManagementGroupId = $mgtGroup.Id
    ResourceGroupName = $RESOURCEGROUPNAME
    Mode              = "Incremental"
    TemplateFile      = "$PSScriptRoot/main.bicep"
}

New-AzManagementGroupDeployment @params
