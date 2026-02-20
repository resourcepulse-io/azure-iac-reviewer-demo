param location string
param environment string

resource appServicePlan 'Microsoft.Web/serverfarms@2023-01-01' = {
  name: 'asp-demo-${environment}'
  location: location
  sku: {
    name: 'B1'
    tier: 'Basic'
  }
  kind: 'linux'
  properties: {
    reserved: true
  }
}

resource webApp 'Microsoft.Web/sites@2023-01-01' = {
  name: 'app-demo-${environment}-${uniqueString(resourceGroup().id)}'
  location: location
  kind: 'app,linux'
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      linuxFxVersion: 'DOTNETCORE|8.0'
      minTlsVersion: '1.2'
    }
  }
}

output webAppUrl string = 'https://${webApp.properties.defaultHostName}'
output webAppName string = webApp.name
