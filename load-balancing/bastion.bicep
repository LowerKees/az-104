param bastionName string = 'bast-az104-001'
param bastionSubnet object
param location string = resourceGroup().location
param pubipName string = 'pip-bast-az104-001'

resource pubip 'Microsoft.Network/publicIPAddresses@2023-04-01' = {
  name: pubipName
  location: location
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  tags: {
    delete: 'yes'
    delete_on: '01-01-2024'
  }
  properties: {
    deleteOption: 'Delete'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
  }
}

resource bastion 'Microsoft.Network/bastionHosts@2021-08-01' = {
  name: bastionName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'IpConf'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: pubip.id
          }
          subnet: {
            id: bastionSubnet.id
          }
        }
      }
    ]
  }
}
