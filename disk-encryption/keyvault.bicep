
param location string = resourceGroup().location
@description('Object id of a single user that gets key vault access through policy')
param userObjectId string

resource keyvault 'Microsoft.KeyVault/vaults@2023-02-01' = {
  name: 'kv-vmde-001'
  location: location
  tags: {
    delete: 'yes'
    delete_on: '01-01-2024'
    delete_policy: 'overnight'
  }
  properties: {
    enabledForDiskEncryption: true
    enabledForTemplateDeployment: true
    networkAcls: {
      defaultAction: 'Allow'
    }
    accessPolicies: [
      {
        objectId: userObjectId
        tenantId: tenant().tenantId
        permissions: {
          keys:[
            'all'
          ]
          secrets: [
            'all'
          ]
        }
      }
    ]
    sku: {
      name: 'standard'
      family: 'A'
    }
    tenantId: tenant().tenantId
  }
}
