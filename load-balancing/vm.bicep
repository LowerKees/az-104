param loadBalancerName string
param location string = resourceGroup().location
@description('The NSG of the subnet that has the VMs mounted in it.')
param nsgVmSubnet object
@description('Name of the load balancer pool containing the compute resources')
param poolName string
@description('Name of the load balancer pool used for outbound connectivity')
param poolOutName string
param vmName string = 'vm'
param vmsSubnet object

var start = 1
var end = 2

resource nic 'Microsoft.Network/networkInterfaces@2023-04-01' = [for i in range(start, end): {
  name: 'nic-${vmName}-00${i}'
  location: location
  tags: {
    delete: 'yes'
    delete_on: '01-01-2024'
  }
  properties: {
    enableIPForwarding: false
    ipConfigurations: [
      {
        name: 'ipconfig'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: vmsSubnet.id
          }
          loadBalancerBackendAddressPools: [
            {
              id: resourceId('Microsoft.Network/loadBalancers/backendAddressPools', loadBalancerName, poolName)
            }
            {
              id: resourceId('Microsoft.Network/loadBalancers/backendAddressPools', loadBalancerName, poolOutName)
            }
          ]
        }
      }
    ]
    networkSecurityGroup: {
      id: nsgVmSubnet.id
    }
  }
}]

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
  properties: {}
}]

output vmName array = [for i in range(start, end): {
  vmName: vm[i].name
}]
