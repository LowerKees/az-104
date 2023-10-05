param lbName string = 'lb-az104-001'
param location string = resourceGroup().location
param pubipName string = 'pip-lb-az104-001'

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

resource loadBalancer 'Microsoft.Network/loadBalancers@2023-05-01' = {
  name: lbName
  location: location
  tags: {
    delete: 'yes'
    delete_on: '01-01-2024'
  }
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    frontendIPConfigurations: [
      {
        name: 'lbFrontendIpConfig'
        properties: {
          publicIPAddress: {
            id: pubip.id
          }
        }
      }
      {
        name: 'lbFrontendIpConfigOutbound'
        properties: {
          
        }
      }
    ]
    backendAddressPools: [
      {
        id: 'string'
        name: 'string'
        properties: {
          drainPeriodInSeconds: 120
          loadBalancerBackendAddresses: [
            {
              name: 'string'
              properties: {
                adminState: 'string'
                ipAddress: 'string'
                loadBalancerFrontendIPConfiguration: {
                  id: 'string'
                }
                subnet: {
                  id: 'string'
                }
                virtualNetwork: {
                  id: 'string'
                }
              }
            }
          ]
          location: 'string'
          syncMode: 'string'
          tunnelInterfaces: [
            {
              identifier: int
              port: int
              protocol: 'string'
              type: 'string'
            }
          ]
          virtualNetwork: {
            id: 'string'
          }
        }
      }
    ]
  }
}
    