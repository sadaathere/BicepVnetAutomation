param location string = resourceGroup().location

module SpokevnetModule 'modules/vnet.bicep' = {
  dependsOn: [
    routeTableModule
    nsgModule
  ]
  name: 'spokeVnet'
  params: {
    location: location
    routeTableID: routeTableModule.outputs.routeTableID
    nsgID: nsgModule.outputs.nsgId
  }
}

module routeTableModule 'modules/udr.bicep' = {
  name: 'testVnet2UDR'
  params: {
    location: location
  }
}

module nsgModule 'modules/nsg.bicep' = {
  name: 'DefaultNSG'
  params: {
    location: location
  }
}

module vnetPeeringModule 'modules/vnetPeering.bicep' = {
  dependsOn:[
    SpokevnetModule
  ]
  name: 'VnetPeering'
  params:{
    secondaryVnetId: SpokevnetModule.outputs.vnetid
  }
}
