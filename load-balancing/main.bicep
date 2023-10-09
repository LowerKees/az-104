param location string = resourceGroup().location

targetScope = 'resourceGroup'

module network 'network.bicep' = {
  name: 'network'
  params: {
    location: location
  }
}

module bastion 'bastion.bicep' = {
  name: 'bastion'
  dependsOn: [
    network
  ]
  params: {
    bastionSubnet: network.outputs.bastionSubnet
    location: location
  }
}

module lb 'load-balancer.bicep' = {
  name: 'loadbalancer'
  params: {
    location: location
  }
}
