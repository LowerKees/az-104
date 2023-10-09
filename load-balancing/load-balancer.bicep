param lbName string = 'lb-az104-001'
param location string = resourceGroup().location
param pubipInName string = 'pip-lb-az104-001'
param pubipOutName string = 'pip-lb-out-az104-001'

resource pubipIn 'Microsoft.Network/publicIPAddresses@2023-04-01' = {
  name: pubipInName
  location: location
  sku: {
    name: 'Standard'
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

resource pubipOut 'Microsoft.Network/publicIPAddresses@2023-04-01' = {
  name: pubipOutName
  location: location
  sku: {
    name: 'Standard'
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

var frontendIpConfigName = 'lbFrontendIpConfigInbound'
var frontendIpConfigNameOutbound = 'lbFrontendIpConfigOutbound'
var poolName = 'lbBackendPool'
var poolProbeName = 'lbBackendPoolProbe'
var poolOutName = 'lbBackendPoolOutbound'

resource loadBalancer 'Microsoft.Network/loadBalancers@2023-05-01' = {
  name: lbName
  location: location
  tags: {
    delete: 'yes'
    delete_on: '01-01-2024'
  }
  sku: {
    name: 'Standard'
  }
  properties: {
    frontendIPConfigurations: [
      {
        name: frontendIpConfigName
        properties: {
          publicIPAddress: {
            id: pubipIn.id
          }
        }
      }
      {
        name: frontendIpConfigNameOutbound
        properties: {
          publicIPAddress: {
            id: pubipOut.id
          }
        }
      }
    ]
    backendAddressPools: [
      {
        name: poolName
      }
      {
        name: poolOutName
      }
    ]
    loadBalancingRules: [
      {
        name: 'myHttpRule'
        properties: {
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', lbName, frontendIpConfigName)
          }
          backendAddressPool: {
            id: resourceId('Microsoft.Network/loadBalancers/backendAddressPools', lbName, poolName)
          }
          frontendPort: 80
          backendPort: 80
          enableFloatingIP: false
          idleTimeoutInMinutes: 15
          protocol: 'Tcp'
          enableTcpReset: true
          loadDistribution: 'Default'
          disableOutboundSnat: true
          probe: {
            id: null
          }
        }
      }
    ]
    probes: [
      {
        name: poolProbeName
        properties: {
          port: 80
          protocol: 'Tcp'
          intervalInSeconds: 10
          numberOfProbes: 1
        }
      }
    ]
    outboundRules: [
      {
        name: 'myOutboundRule'
        properties: {
          protocol: 'All'
          allocatedOutboundPorts: 10000
          enableTcpReset: true
          idleTimeoutInMinutes: 15
          frontendIPConfigurations: [
            {
              id: resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', lbName, frontendIpConfigNameOutbound)
            }
          ]
          backendAddressPool: {
            id: resourceId('Microsoft.Network/loadBalancers/backendAddressPools', lbName, poolOutName)
          }
        }
      }
    ]
  }
}
    