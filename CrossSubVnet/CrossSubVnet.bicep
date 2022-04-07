param name string = 'testVnet2'
param location string = resourceGroup().location
param subnetName1 string = 'subnet-1'
param subnetPrefix1 string = '10.0.0.0/24'
param subnetName2 string = 'subnet-2'
param subnetPrefix2 string = '10.1.0.0/24'
param addressPrefix string = '10.0.0.0/16'
param nsgID string = ''
param routeTableID string = ''

resource myVnet 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: [
      {
        name: subnetName1
        properties: {
          addressPrefix: subnetPrefix1
          networkSecurityGroup: {
            id: nsgID
          }
          routeTable: {
            id: routeTableID
          }
        }
      }
      {
        name: subnetName2
        properties: {
          addressPrefix: subnetPrefix2
        }
      }
    ]
  }
}
output vnetid string = myVnet.id