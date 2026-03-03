@description('Azure region')
param location string

@description('Environment name')
param env string

@description('Application name')
param appName string

resource redis 'Microsoft.Cache/redis@2023-08-01' = {
  name: '${appName}-${env}-cache'
  location: location
  properties: {
    sku: {
      name: 'Standard'
      family: 'C'
      capacity: 1
    }
    enableNonSslPort: false
    minimumTlsVersion: '1.2'
    redisConfiguration: {
      'maxmemory-policy': 'allkeys-lru'
    }
  }
  tags: {
    environment: env
    managedBy: 'bicep'
  }
}

output redisHostName string = redis.properties.hostName
