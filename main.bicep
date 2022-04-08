targetScope = 'subscription'
//location variable
param location string = 'West US 2'

//SpokeVnet Settings
param SpokeVnetSettings object = {
  spokeName: 'spokeVnet2'
  spokeLocation: 'West US 2'
  spokePrefixAddress: '10.190.0.0/16'
  spokeSubnetName1: 'Default-sub'
  spokeSubnet1: '10.190.0.0/24'
  spokeSubnetName2: 'Prod-sub'
  spokeSubnet2: '10.190.1.0/24'
}
//Spoke to Hub peering
@description('Make sure to use right naming convention. vnetName/peeringName')

param spokePeeringName string = 'spokeVnet2/Spoke2ToHubPeer'

// Spoke Subscription and resourceGroup ID
@description('Make sure to refer correct ResourceGroup and Subscription ID')

param spokeResourceGroup string = 'demo-rg'
param spokesubscriptionId string = 'd222169f-abbc-4278-93f7-24adc6b3eecc'

//spoke NSG
@description('Add desired nsg name')

param nsgName string = 'nsg-spoke2'

//Spoke RouteTable
@description('Add desired RouteTable configs') 

param SpokeRoutesSettings object = {
  rtName:'spokeRouteTable'
  rtRouteName:'0.0.0.0m0'
  rtAddressPrefix:'0.0.0.0/0'
  rtNextHopIpAddress:'10.180.4.4'
  rtNextHopType:'VirtualAppliance'
}

// tags for hubsubscription
@description('This object will add tags to resource. Make sure tags are referred in resource and module')

param spokeTag object = {
  spokeApp: 'sanbox'
  spokeEnv: 'Development'
}

// hub subscription id and resroucegroup
@description('Make sure to add correct hub resourceGroup and Subscription ID')

param hubResourceGroup string = 'Networking'
param hubSubscriptionId string = 'cea97a1c-9fa5-4fce-ad5a-11e6c6d52020'

//Hub to Spoke Peering

@description('Make sure to use right naming convention. vnetName/peeringName')

param hubPeeringName string = 'hubVnet/HubToSpokePeer2'

//Hub RouteTable
@description('This will add routes to hub route table') 

param hubRoutesSettings object = {
  rtName:'rt-demo-table/10.190.0.0m24'
  rtAddressPrefix:'10.180.190.0/24'
  rtNextHopIpAddress:'10.180.4.4'
  rtNextHopType:'VirtualAppliance'
}

// This Module will create Vnet
@description('This will deploy Spoke Vnet')

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

// This module will create Route table for the Vnet
@description('This will deploy spokeVnet route table')

module routeTableModule 'modules/spokeRouteTable.bicep' = {
  scope: resourceGroup(spokesubscriptionId, spokeResourceGroup)
  name: SpokeRoutesSettings.rtName
  params: {
    location: location
    rtSpokeName: SpokeRoutesSettings.rtName
    rtRouteName: SpokeRoutesSettings.rtRouteName
    rtSpokeAddressPrefix:SpokeRoutesSettings.rtAddressPrefix
    rtSpokeHopType:SpokeRoutesSettings.rtNextHopType
    rtSpokeHopIpAddress:SpokeRoutesSettings.rtNextHopIpAddress
  }
}

// This module will create NSG for the Vnet
@description('This is deploy nsg for spoke')

module nsgModule 'modules/nsg.bicep' = {
  scope:resourceGroup(spokesubscriptionId, spokeResourceGroup)
  name: nsgName
  params: {
    location: location
    name: nsgName
  }
}


// This module will peer Spoke with Hub
@description('This module will peer spoke vnet to hub vnet')

module spokeVnetPeeringModule 'modules/vnetPeering.bicep' = {
  scope: resourceGroup(spokesubscriptionId,spokeResourceGroup)
  dependsOn: [
    SpokeVnetModule
    
  ]
  name : 'spokePeering'
  params: {
    vnetName:spokePeeringName
    remoteVnetId:existingHubVnet.id
    remoteGateways: false
  }
}

// This resource is for reference and output existing hub vnet id
@description('This is used to output existing hubvnet id')

resource existingHubVnet 'Microsoft.Network/virtualNetworks@2019-11-01' existing= {
  scope:resourceGroup(hubSubscriptionId,hubResourceGroup)
  name: 'hubVnet'
}


// This module will peer Hub to Spoke
@description('This module will peer hub vnet to spoke vnet')

module hubVnetPeeringModule 'modules/vnetPeering.bicep' = {
  scope:resourceGroup(hubSubscriptionId,hubResourceGroup)
  dependsOn: [
    SpokeVnetModule
    
  ]
  name: 'hubPeeringName'
  params:{
    vnetName:hubPeeringName
    remoteVnetId: SpokeVnetModule.outputs.vnetid
    remoteGateways: false
  }
}

// This module will add route to Hub Routing Table
@description('This module will add routes to existing hub route table')

module hubRouteTable 'modules/hub-routetable-routes.bicep' = {
  scope:resourceGroup(hubSubscriptionId,hubResourceGroup)
  name: 'rt-demo-table'
  params:{
    rtName:hubRoutesSettings.rtName
    rtAddressPrefix:hubRoutesSettings.rtAddressPrefix
    rtNextHopIpAddress:hubRoutesSettings.rtNextHopIpAddress
    rtNextHopType:hubRoutesSettings.rtNextHopType
  }
}
