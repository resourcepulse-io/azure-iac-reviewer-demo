@description('Azure region')
param location string

@description('Environment name')
param env string

@description('Application name')
param appName string

var skuName = env == 'prod' ? 'Standard_GRS' : 'Standard_LRS'

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: '${appName}${env}sa'
  location: location
  kind: 'StorageV2'
  sku: {
    name: skuName
  }
  properties: {
    accessTier: 'Hot'
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    supportsHttpsTrafficOnly: true
  }
  tags: {
    environment: env
    managedBy: 'bicep'
  }
}

output storageAccountName string = storageAccount.name
