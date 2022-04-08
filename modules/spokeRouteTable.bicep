param location string 
param rtSpokeName string
param rtRouteName string 
param rtSpokeAddressPrefix string
param rtSpokeHopType string
param rtSpokeHopIpAddress string

resource myRouteTable 'Microsoft.Network/routeTables@2019-11-01' = {
  name: rtSpokeName
  location: location
  properties: {
    routes: [
      {
        name: rtRouteName
        properties: {
          addressPrefix: rtSpokeAddressPrefix
          nextHopType: rtSpokeHopType
          nextHopIpAddress: rtSpokeHopIpAddress

        }
      }
    ]
    disableBgpRoutePropagation: true
  }
}
output routeTableID string = myRouteTable.id
