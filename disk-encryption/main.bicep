param location string = resourceGroup().location
@description('Object id of a single user that gets key vault access through policy')
param userObjectId string
@secure()
param vmUsername string
@secure()
param vmPassword string

targetScope = 'resourceGroup'

module keyvault 'keyvault.bicep' = {
  name: 'keyvault'
  params:{
    location: location
    userObjectId: userObjectId
  }
}
