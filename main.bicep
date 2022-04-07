param location string = resourceGroup().location

module vnetModule 'vnet.bicep'= {
  dependsOn: [
    routeTableModule
  ]
  name: 'myVnet'
  params: {
    location : location
    routeTableID: routeTableModule.outputs.routeTableID
  }
}

module routeTableModule 'udr.bicep' = {
  name : 'testVnet2UDR'
  params: {
    location: location
  }
} 
