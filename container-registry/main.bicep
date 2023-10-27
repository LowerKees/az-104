
module acr 'container-registry.bicep' = {
  name: 'acr'
  params: {
    location: resourceGroup().location
  }
}
