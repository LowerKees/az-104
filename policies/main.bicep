param managementGroupName string

targetScope = 'managementGroup'

var mgScope = tenantResourceId('Microsoft.Management/managementGroups', managementGroupName)

module vm 'vm-policies.bicep' = {
  name: 'vm-policies'
  params: {
    mgScope: mgScope
  }
}
