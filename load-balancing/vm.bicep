param location string = resourceGroup().location
param vmName string = 'vm'

var start = 0
var end = 1

resource vm 'Microsoft.Compute/virtualMachines@2023-07-01' = [for i in range(start, end): {
  name: 'vm-${vmName}-00${i}'
  location: location
  tags: {
    delete: 'yes'
    delete_on: '01-01-2024'  
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: {

  }
}]

output vmName array = [for i in range(start, end): {
  vmName: vm[i].name
}]
