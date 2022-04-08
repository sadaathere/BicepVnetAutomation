
param rtName string
param rtAddressPrefix string
param rtNextHopType string
param rtNextHopIpAddress string


resource routeTableRoute 'Microsoft.Network/routeTables/routes@2019-11-01' = {
  name: rtName
  properties: {
    addressPrefix: rtAddressPrefix
    nextHopType: rtNextHopType
    nextHopIpAddress: rtNextHopIpAddress
  }
}

output rtId string = routeTableRoute.id
