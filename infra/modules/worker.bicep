param location string
param environment string
param adminUsername string = 'azureuser'

resource workerVm 'Microsoft.Compute/virtualMachines@2023-09-01' = {
  name: 'vm-worker-${environment}'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D8s_v3'
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
      computerName: 'vm-worker'
      adminUsername: adminUsername
      linuxConfiguration: {
        disablePasswordAuthentication: true
      }
    }
    networkProfile: {
      networkInterfaces: []
    }
  }
  tags: {
    environment: environment
  }
}

output workerVmName string = workerVm.name
