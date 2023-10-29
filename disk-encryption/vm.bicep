@secure()
param adminPassword string
@secure()
param adminUsername string
param location string = resourceGroup().location
param vmName string = 'vmde'
param vmsSubnet object

resource nic 'Microsoft.Network/networkInterfaces@2023-04-01' = {
  name: 'nic-${vmName}-001'
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
}

resource vm 'Microsoft.Compute/virtualMachines@2023-07-01' = {
  name: 'vm-${vmName}-001'
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
      vmSize: 'Standard_B2s'
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
      dataDisks: [
        {
          diskSizeGB: 10
          
        }
      ]
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic[i-1].id
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
  vmName: vm[i-1].name
}]
