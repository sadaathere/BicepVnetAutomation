param remoteVnetId string
param vnetName string
param remoteGateways bool  

resource myVnetPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-07-01' = {
  name: vnetName
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: true
    useRemoteGateways: remoteGateways
    remoteVirtualNetwork: {
      id: remoteVnetId
    }
  }
}
