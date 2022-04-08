param name string 
param location string 

resource MyNSG 'Microsoft.Network/networkSecurityGroups@2019-11-01' = {
  name: name
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
output nsgId string = MyNSG.id
