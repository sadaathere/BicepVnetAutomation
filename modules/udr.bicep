param location string = resourceGroup().location
param name string = 'testVnet2UDR'

resource myRouteTable 'Microsoft.Network/routeTables@2019-11-01' = {
  name: name
  location: location
  properties: {
    routes: [
      {
        name: '0.0.0.0m0'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: '10.180.4.4'
        }
      }
    ]
    disableBgpRoutePropagation: false
  }
}
output routeTableID string = myRouteTable.id
