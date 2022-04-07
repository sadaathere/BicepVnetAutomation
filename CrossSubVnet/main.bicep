targetScope = 'subscription'
//hubVnet Setings
param hubName string = 'hubVnet'
param hublocation string = 'West US 2'
param hubPrefixAddress string = '10.0.0.0/16'
param hubSubnet1 string = '10.0.0.0/24'
param hubSubnet2 string = '10.1.0.0/24'
param hubResourceGroup string = 'Networking'
param hubSubscriptionId string = 'cea97a1c-9fa5-4fce-ad5a-11e6c6d52020'

//SpokeVnet Settings
param spokeName string = 'hubVnet'
param Spokelocation string = 'West US 2'
param spokePrefixAddress string = '10.0.0.0/16'
param spokeSubnet1 string = '10.0.0.0/24'
param spokeSubnet2 string = '10.1.0.0/24'
param spokeResourceGroup string = 'demo-rg'
param spokesubscriptionId string = 'd222169f-abbc-4278-93f7-24adc6b3eecc'

module HubVnetModule 'CrossSubVnet.bicep' = {
  scope: resourceGroup(hubSubscriptionId,hubResourceGroup)
  name: hubName
  params:{
  location : hublocation
  addressPrefix: hubPrefixAddress
  subnetName1: hubSubnet1
  subnetName2: hubSubnet2
  }
  
}

module SpokeVnetModule 'CrossSubVnet.bicep' = {
  scope: resourceGroup(spokesubscriptionId,spokeResourceGroup)
  name: spokeName
  params:{
  location : Spokelocation
  addressPrefix: spokePrefixAddress
  subnetName1: spokeSubnet1
  subnetName2: spokeSubnet2
  }
  
}
