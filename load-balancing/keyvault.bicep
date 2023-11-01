
param location string = resourceGroup().location

@secure()
param adminPasswords object
@secure()
param adminUsernames object

@description('Object id of a single user that gets key vault access through policy')
param userObjectId string

resource keyvault 'Microsoft.KeyVault/vaults@2023-02-01' = {
  name: 'kv-lb-001'
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

resource usernames 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = [for i in range(1, 2): {
  parent: keyvault
  name: 'adminUsernameVm${i}'
  properties: {
    value: adminUsernames['vm${i}']
  }
}]

resource passwords 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = [for i in range(1, 2): {
  parent: keyvault
  name: 'adminPasswordVm${i}'
  properties: {
    value: adminPasswords['vm${i}']
  }
}]
