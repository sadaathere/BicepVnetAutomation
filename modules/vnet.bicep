param name1 string 
param location1 string 
param subnetName1 string 
param subnetPrefix1 string 
param subnetName2 string 
param subnetPrefix2 string 
param addressPrefix1 string
param apptag string
param envtag string
param nsgNameId string
param rtNameId string 

resource myVnet 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: name1
  tags: {
    Application: apptag
    Environment: envtag
  }
  location: location1
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix1
      ]
    }
    subnets: [
      {
        name: subnetName1
        properties: {
          addressPrefix: subnetPrefix1
          networkSecurityGroup: {
            id: nsgNameId
          }
          routeTable: {
            id: rtNameId
          }
        }
      }
      {
        name: subnetName2
        properties: {
          addressPrefix: subnetPrefix2
          networkSecurityGroup:{
            id: nsgNameId
          }
          routeTable:{
            id:rtNameId
          }
        }
      }
    ]
  }
}
output vnetid string = myVnet.id
