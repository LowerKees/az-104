@secure()
param adminPasswords object
@secure()
param adminUsernames object
param loadBalancerName string
param location string = resourceGroup().location
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
  dependsOn: [
    nic
  ]
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B1s'
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: '0001-com-ubuntu-server-jammy'
        sku: '22_04-lts-gen2'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        caching: 'ReadOnly'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic[i].id
        }
      ]
    }
    osProfile: {
      computerName: 'mountain-${i}'
      allowExtensionOperations: true
      adminPassword: adminPasswords['vm${i}']
      adminUsername: adminUsernames['vm${i}']
      linuxConfiguration: {
        patchSettings: {
          assessmentMode: 'AutomaticByPlatform'
          patchMode: 'AutomaticByPlatform'
          automaticByPlatformSettings: {
            rebootSetting: 'IfRequired'
          }
        }
      }
    }
  }
}]

output vmName array = [for i in range(start, end): {
  vmName: vm[i].name
}]
