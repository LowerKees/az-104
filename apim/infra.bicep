@description('The name of the API management service instance')
param name string = 'apim-${uniqueString(resourceGroup().id)}'

param publisherEmail string = 'martijn.beenker@gmail.com'

param publisherName string = 'Martijn Beenker'

@allowed([
  'Developer'
  'Consumption'
])
param sku string = 'Consumption'

param skuCount int = 1

param location string = resourceGroup().location

resource apim 'Microsoft.ApiManagement/service@2024-06-01-preview' = {
  name: name
  location: location
  sku: {
    name: sku
    capacity: skuCount
  }
  properties: {
    publisherEmail: publisherEmail
    publisherName: publisherName
  }
}
