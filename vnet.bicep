param name string = 'testVnet2'
param location string = resourceGroup().location
param subnetName1 string = 'subnet-1'
param subnetPrefix1 string = '10.180.0.0/24'
param subnetName2 string = 'subnet-2'
param subnetPrefix2 string = '10.180.1.0/24'
param addressPrefix string = '10.180.0.0/16'
param remoteVnetId string = '/subscriptions/d222169f-abbc-4278-93f7-24adc6b3eecc/resourceGroups/demo-rg/providers/Microsoft.Network/virtualNetworks/testVnet'
param defaultNSG string = 'DefaultNSG'
param VnetPeerName string = 'testVnet2ToTestVnet1'
param routeTableID string = ''

resource myVnet01 'Microsoft.Network/virtualNetworks@2019-11-01' = {
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
            id: MyNSG.id
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
    virtualNetworkPeerings: [
      {
        name: VnetPeerName
        properties: {
          allowVirtualNetworkAccess: true
          allowForwardedTraffic: true
          allowGatewayTransit: true
          remoteVirtualNetwork: {
            id: remoteVnetId
          }
        }
      }
    ]
  }
}

resource PeeringTestVnet1toTestVnet2 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-07-01' = {
  name: 'testVnet/testVnet1toTestVnet2'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: true
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: myVnet01.id
    }
  }
}

resource MyNSG 'Microsoft.Network/networkSecurityGroups@2019-11-01' = {
  name: defaultNSG
  location: location
  properties: {
    securityRules: [
      {
        name: 'DenyAll'
        properties: {
          description: 'description'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 999
          direction: 'Inbound'
        }
      }
    ]
  }
}
