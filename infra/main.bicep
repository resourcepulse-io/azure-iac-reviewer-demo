param location string = resourceGroup().location
param environment string = 'dev'

module storage 'modules/storage.bicep' = {
  name: 'storage'
  params: {
    location: location
    environment: environment
  }
}

module appservice 'modules/appservice.bicep' = {
  name: 'appservice'
  params: {
    location: location
    environment: environment
  }
}

module postgres 'modules/postgres.bicep' = {
  name: 'postgres'
  params: {
    location: location
    environment: environment
  }
}

module redis 'modules/redis.bicep' = {
  name: 'redis'
  params: {
    location: location
    environment: environment
  }
}

module acr 'modules/acr.bicep' = {
  name: 'acr'
  params: {
    location: location
    environment: environment
  }
}

module keyvault 'modules/keyvault.bicep' = {
  name: 'keyvault'
  params: {
    location: location
    environment: environment
  }
}

output storageAccountName string = storage.outputs.storageAccountName
output webAppUrl string = appservice.outputs.webAppUrl
output postgresHost string = postgres.outputs.postgresHost
output acrLoginServer string = acr.outputs.loginServer
output keyVaultName string = keyvault.outputs.keyVaultName
