param primeVnetId string = '/subscriptions/d222169f-abbc-4278-93f7-24adc6b3eecc/resourceGroups/demo-rg/providers/Microsoft.Network/virtualNetworks/testVnet'
param secondaryVnetId string = ''
param vnet2 string = 'testVnet2/Vnet2toVnet1'
param vnet1 string = 'testVnet/testVnet1toTestVnet2'

resource PeeringTestVnet2toTestVnet1 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-07-01' = {
  name: vnet2
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: true
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: primeVnetId
    }
  }
}


resource PeeringTestVnet1toTestVnet2 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-07-01' = {
  name: vnet1
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: true
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: secondaryVnetId
    }
  }
}
