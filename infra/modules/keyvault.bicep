@description('Azure region')
param location string

@description('Environment name')
param env string

@description('Application name')
param appName string

var skuName = env == 'prod' ? 'premium' : 'standard'

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: '${appName}-${env}-kv'
  location: location
  properties: {
    sku: {
      family: 'A'
      name: skuName
    }
    tenantId: subscription().tenantId
    enableSoftDelete: true
    softDeleteRetentionInDays: env == 'prod' ? 90 : 7
    enableRbacAuthorization: true
    publicNetworkAccess: 'Disabled'
  }
  tags: {
    environment: env
    managedBy: 'bicep'
  }
}

output keyVaultUri string = keyVault.properties.vaultUri
