
param location string = resourceGroup().location
@secure()
param vmPasswords object
@secure()
param vmUsernames object

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

module vms 'vm.bicep' = {
  name: 'virtualmachines'
  params: {
    adminPasswords: vmPasswords
    adminUsernames: vmUsernames
    loadBalancerName: lb.outputs.loadBalancerName
    location: location
    poolName: lb.outputs.poolName
    poolOutName: lb.outputs.poolOutName
    vmsSubnet: network.outputs.vmsSubnet
  }
  dependsOn:[
    lb
    network
  ]
}
