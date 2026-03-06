param location string
param environment string

resource vm 'Microsoft.Compute/virtualMachines@2023-03-01' = {
  name: 'vm-demo-${environment}'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D16s_v3'
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
      computerName: 'vm-demo'
      adminUsername: 'azureuser'
      linuxConfiguration: {
        disablePasswordAuthentication: true
        ssh: {
          publicKeys: []
        }
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

output vmName string = vm.name
