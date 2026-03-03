@description('Azure region')
param location string

@description('Environment name')
param env string

@description('Application name')
param appName string

var throughput = env == 'prod' ? 1000 : 400

resource cosmosAccount 'Microsoft.DocumentDB/databaseAccounts@2024-02-15-preview' = {
  name: '${appName}-${env}-cosmos'
  location: location
  kind: 'GlobalDocumentDB'
  properties: {
    databaseAccountOfferType: 'Standard'
    consistencyPolicy: {
      defaultConsistencyLevel: env == 'prod' ? 'Session' : 'Eventual'
    }
    locations: [
      {
        locationName: location
        failoverPriority: 0
        isZoneRedundant: env == 'prod'
      }
    ]
    enableFreeTier: env != 'prod'
    publicNetworkAccess: 'Disabled'
  }
  tags: {
    environment: env
    managedBy: 'bicep'
  }
}

resource database 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2024-02-15-preview' = {
  parent: cosmosAccount
  name: 'appdb'
  properties: {
    resource: {
      id: 'appdb'
    }
    options: {
      throughput: throughput
    }
  }
}

output cosmosEndpoint string = cosmosAccount.properties.documentEndpoint
