targetScope = 'subscription'
//location variable
param location string = 'West US 2'

//SpokeVnet Settings
param SpokeVnetSettings object = {
  spokeName: 'spokeVnet'
  spokeLocation: 'West US 2'
  spokePrefixAddress: '10.160.0.0/16'
  spokeSubnetName1: 'Default-sub'
  spokeSubnet1: '10.160.0.0/24'
  spokeSubnetName2: 'Prod-sub'
  spokeSubnet2: '10.160.1.0/24'
}
param spokeResourceGroup string = 'demo-rg'
param spokesubscriptionId string = 'd222169f-abbc-4278-93f7-24adc6b3eecc'

// tags for hubsubscription
param spokeTag object = {
  spokeApp: 'sanbox'
  spokeEnv: 'Development'
}

// hub subscription id and resroucegroup
param hubResourceGroup string = 'Networking'
param hubSubscriptionId string = 'cea97a1c-9fa5-4fce-ad5a-11e6c6d52020'

module SpokeVnetModule 'modules/vnet.bicep' = {
  scope: resourceGroup(spokesubscriptionId, spokeResourceGroup)
  dependsOn: [
    routeTableModule
    nsgModule
    existingHubVnet
  ]
  name: SpokeVnetSettings.spokeName
  params: {
    envtag: spokeTag.spokeApp
    apptag: spokeTag.spokeEnv
    name1: SpokeVnetSettings.spokeName
    location1: SpokeVnetSettings.Spokelocation
    addressPrefix1: SpokeVnetSettings.spokePrefixAddress
    subnetName1: SpokeVnetSettings.spokeSubnetName1
    subnetPrefix1: SpokeVnetSettings.spokeSubnet1
    subnetName2: SpokeVnetSettings.spokeSubnetName2
    subnetPrefix2: SpokeVnetSettings.spokeSubnet2
    nsgNameId: nsgModule.outputs.nsgId
    rtNameId: routeTableModule.outputs.routeTableID
  }
}

module routeTableModule 'modules/udr.bicep' = {
  scope: resourceGroup(spokesubscriptionId, spokeResourceGroup)
  name: 'testVnet2UDR'
  params: {
    location: location
  }
}

module nsgModule 'modules/nsg.bicep' = {
  scope:resourceGroup(spokesubscriptionId, spokeResourceGroup)
  name: 'DefaultNSG'
  params: {
    location: location
  }
}

//Spoke to Hub peering
param spokePeeringName string = 'spokeVnet/SpokeToHubPeer'
module spokeVnetPeeringModule 'modules/vnetPeering.bicep' = {
  scope: resourceGroup(spokesubscriptionId,spokeResourceGroup)
  dependsOn: [
    SpokeVnetModule
    existingHubVnet
  ]
  name : 'spokePeering'
  params: {
    vnetName:spokePeeringName
    remoteVnetId:existingHubVnet.id
    remoteGateways: false
  }
}

resource existingHubVnet 'Microsoft.Network/virtualNetworks@2019-11-01' existing= {
  scope:resourceGroup(hubSubscriptionId,hubResourceGroup)
  name: 'hubVnet'
}

//Hub to Spoke Peering
param hubPeeringName string = 'hubVnet/HubToSpokePeer'
module hubVnetPeeringModule 'modules/vnetPeering.bicep' = {
  scope:resourceGroup(hubSubscriptionId,hubResourceGroup)
  dependsOn: [
    SpokeVnetModule
    existingHubVnet
  ]
  name: 'hubPeeringName'
  params:{
    vnetName:hubPeeringName
    remoteVnetId: SpokeVnetModule.outputs.vnetid
    remoteGateways: false
  }
}
