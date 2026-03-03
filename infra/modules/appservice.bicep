@description('Azure region')
param location string

@description('Environment name')
param env string

@description('Application name')
param appName string

var planSku = env == 'prod'
  ? { name: 'P2v3', tier: 'PremiumV3', size: 'P2v3', family: 'Pv3', capacity: 2 }
  : { name: 'P1v3', tier: 'PremiumV3', size: 'P1v3', family: 'Pv3', capacity: 1 }

resource appServicePlan 'Microsoft.Web/serverfarms@2023-01-01' = {
  name: '${appName}-${env}-plan'
  location: location
  sku: planSku
  properties: {
    reserved: true // Linux
  }
  tags: {
    environment: env
    managedBy: 'bicep'
  }
}

resource webApp 'Microsoft.Web/sites@2023-01-01' = {
  name: '${appName}-${env}-app'
  location: location
  kind: 'app,linux'
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      linuxFxVersion: 'NODE|20-lts'
      minTlsVersion: '1.2'
      ftpsState: 'Disabled'
    }
  }
  tags: {
    environment: env
    managedBy: 'bicep'
  }
}

output appServiceUrl string = 'https://${webApp.properties.defaultHostName}'
