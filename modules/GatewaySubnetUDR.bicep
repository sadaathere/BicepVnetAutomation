param name string = 'rt-test'
param location string = resourceGroup().location
param defaultRoute string = '0.0.0.0m0'
param addressPrefix string = '10.180.16.0/22'
param nexthopIp string = '10.180.4.4'
param secondRoute string = '10.180.15.0m22'

resource routeTable 'Microsoft.Network/routeTables@2019-11-01' = {
  name: name
  location: location
  tags:{
    Environment: 'Development'
    Application: 'L360'
  }
  properties: {
    routes: [
      {
        name: defaultRoute
        properties: {
          addressPrefix: addressPrefix
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: nexthopIp
        }
      }
      {
        name: secondRoute
        properties:{
          addressPrefix:'10.180.12.0/22'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: nexthopIp
        }
      }
    ]
    disableBgpRoutePropagation: false
  }
}
