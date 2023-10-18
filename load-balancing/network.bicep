param location string = resourceGroup().location
param vnetName string = 'vnet-az104-001'

resource network 'Microsoft.Network/virtualNetworks@2023-04-01' = {
  name: vnetName
  location: location
  tags: {
    delete: 'yes'
    delete_on: '01-01-2024'
  }
  properties: {
    ipAllocations: [
      
    ]
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
        '10.1.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'vms'
        properties: {
          addressPrefix: '10.0.0.0/24'
        }
      }
      {
        name: 'AzureBastionSubnet'
        properties: {
          addressPrefix: '10.0.1.0/24'
        }
      }
    ]
  }
}

output bastionSubnet object = network.properties.subnets[1]
output vmsSubnet object = network.properties.subnets[0]
