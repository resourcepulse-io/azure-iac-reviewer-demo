param location string = resourceGroup().location
param environment string = 'dev'

module storage 'modules/storage.bicep' = {
  name: 'storage'
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

module appinsights 'modules/appinsights.bicep' = {
  name: 'appinsights'
  params: {
    location: location
    environment: environment
  }
}

output storageAccountName string = storage.outputs.storageAccountName
output postgresHost string = postgres.outputs.postgresHost
output instrumentationKey string = appinsights.outputs.instrumentationKey
