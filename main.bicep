param location string = resourceGroup().location

module vnetModule 'vnet.bicep' = {
  dependsOn: [
    routeTableModule
    nsgModule
  ]
  name: 'testVnet2'
  params: {
    location: location
    routeTableID: routeTableModule.outputs.routeTableID
    nsgID: nsgModule.outputs.nsgId
  }
}

module routeTableModule 'udr.bicep' = {
  name: 'testVnet2UDR'
  params: {
    location: location
  }
}

module nsgModule 'nsg.bicep' = {
  name: 'DefaultNSG'
  params: {
    location: location
  }
}

module vnetPeeringModule 'vnetPeering.bicep' = {
  dependsOn:[
    vnetModule
  ]
  name: 'VnetPeering'
  params:{
    secondaryVnetId: vnetModule.outputs.vnetid
  }
}
