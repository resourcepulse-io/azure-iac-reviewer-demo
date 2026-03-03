@description('Azure region')
param location string

@description('Environment name')
param env string

@description('Application name')
param appName string

@description('SQL administrator login')
param sqlAdminLogin string = 'sqladmin'

resource sqlServer 'Microsoft.Sql/servers@2023-05-01-preview' = {
  name: '${appName}-${env}-sql'
  location: location
  properties: {
    administratorLogin: sqlAdminLogin
    administratorLoginPassword: 'REPLACE_WITH_SECRET'
    minimalTlsVersion: '1.2'
    publicNetworkAccess: 'Disabled'
  }
  tags: {
    environment: env
    managedBy: 'bicep'
  }
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@2023-05-01-preview' = {
  parent: sqlServer
  name: '${appName}-${env}-db'
  location: location
  sku: {
    name: 'GP_Gen5_4'
    tier: 'GeneralPurpose'
    capacity: 4
  }
  properties: {
    zoneRedundant: false
    requestedBackupStorageRedundancy: 'Local'
  }
}

output sqlServerFqdn string = sqlServer.properties.fullyQualifiedDomainName
