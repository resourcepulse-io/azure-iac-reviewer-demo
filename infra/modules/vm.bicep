@description('Azure region')
param location string

@description('Environment name')
param env string

@description('Application name')
param appName string

resource vm 'Microsoft.Compute/virtualMachines@2023-09-01' = {
  name: '${appName}-${env}-vm'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D4s_v3'
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: '0001-com-ubuntu-server-jammy'
        sku: '22_04-lts-gen2'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
      }
    }
    osProfile: {
      computerName: '${appName}-${env}'
      adminUsername: 'azureuser'
      linuxConfiguration: {
        disablePasswordAuthentication: true
        ssh: {
          publicKeys: [
            {
              path: '/home/azureuser/.ssh/authorized_keys'
              keyData: 'ssh-rsa PLACEHOLDER'
            }
          ]
        }
      }
    }
    networkProfile: {
      networkInterfaces: []
    }
  }
  tags: {
    environment: env
    managedBy: 'bicep'
  }
}
