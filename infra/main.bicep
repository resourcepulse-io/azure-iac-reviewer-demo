@description('Environment name (dev, staging, prod)')
param env string = 'dev'

@description('Primary Azure region for all resources')
param location string = 'westeurope'

@description('Short application name used in resource naming')
param appName string = 'myapp'

// ── Modules ──────────────────────────────────────────────────────────────────

module storage 'modules/storage.bicep' = {
  name: 'storage'
  params: {
    location: location
    env: env
    appName: appName
  }
}

module appservice 'modules/appservice.bicep' = {
  name: 'appservice'
  params: {
    location: location
    env: env
    appName: appName
  }
}

module keyvault 'modules/keyvault.bicep' = {
  name: 'keyvault'
  params: {
    location: location
    env: env
    appName: appName
  }
}

module cosmos 'modules/cosmos.bicep' = {
  name: 'cosmos'
  params: {
    location: location
    env: env
    appName: appName
  }
}

module vm 'modules/vm.bicep' = {
  name: 'vm'
  params: {
    location: location
    env: env
    appName: appName
  }
}

module database 'modules/database.bicep' = {
  name: 'database'
  params: {
    location: location
    env: env
    appName: appName
  }
}

module redis 'modules/redis.bicep' = {
  name: 'redis'
  params: {
    location: location
    env: env
    appName: appName
  }
}

// ── Outputs ───────────────────────────────────────────────────────────────────

output storageAccountName string = storage.outputs.storageAccountName
output appServiceUrl string = appservice.outputs.appServiceUrl
output keyVaultUri string = keyvault.outputs.keyVaultUri
output cosmosEndpoint string = cosmos.outputs.cosmosEndpoint
output sqlServerFqdn string = database.outputs.sqlServerFqdn
output redisHostName string = redis.outputs.redisHostName
