param location string
param environment string

resource serviceBusNamespace 'Microsoft.ServiceBus/namespaces@2022-10-01-preview' = {
  name: 'sb-demo-${environment}-${uniqueString(resourceGroup().id)}'
  location: location
  sku: {
    name: 'Premium'
    tier: 'Premium'
  }
  tags: {
    environment: environment
  }
}

resource ordersQueue 'Microsoft.ServiceBus/namespaces/queues@2022-10-01-preview' = {
  parent: serviceBusNamespace
  name: 'orders'
  properties: {
    maxSizeInMegabytes: 1024
    defaultMessageTimeToLive: 'P14D'
  }
}

output serviceBusEndpoint string = serviceBusNamespace.properties.serviceBusEndpoint
