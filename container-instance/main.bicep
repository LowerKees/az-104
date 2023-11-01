param location string = resourceGroup().location

targetScope = 'resourceGroup'

module aci 'container-instance.bicep' = {
  name: 'aci'
  params: {
    location: location
  }
}
