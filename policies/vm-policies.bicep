param mgScope string

resource vm_sku 'Microsoft.Authorization/policyDefinitions@2023-04-01' = {
  name: 'pol_vm_sku'
  scope: mgScope
  properties: {
    description: 'Virtual Machine SKU should comply with a pre-defined SKU list'
    displayName: 'Virtual Machine allowed SKUs'
    mode: 'all'
    parameters: {
      'allowedSkus': {
        type: 'Array'
        metadata: {
          displayName: 'Allowed SKUs'
          description: 'Allowed VM SKUs' 
        }
        allowedValues: [
          'Standard_B1s'
          'Standard_B2s'
        ]
      }
    }
    policyRule: {
      'if': {
        'allOf': [
          {
            'field': ''
          }
        ]
      }
    }
  }
}

resource vm_initiative 'Microsoft.Authorization/policySetDefinitions@2023-04-01' = {
  name: 'ini_vm'
  scope: mgScope
  dependsOn: [
    vm_sku
  ]
  properties: {
    policyDefinitions: [
      vm_sku
    ]
    description: 'Custom policies for Virtual Machines'
    displayName: 'Custom VM Policies'
    policyType: 'Custom'
  }
}
