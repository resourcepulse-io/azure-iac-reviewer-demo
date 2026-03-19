param location string
param environment string

resource serviceBusNamespace 'Microsoft.ServiceBus/namespaces@2022-10-01-preview' = {
  name: 'sb-demo-${environment}-${uniqueString(resourceGroup().id)}'
  location: location
  sku: {
    name: 'Premium'
    tier: 'Premium'
    capacity: 1
  }
  tags: {
    environment: environment
  }
}

output serviceBusEndpoint string = serviceBusNamespace.properties.serviceBusEndpoint
