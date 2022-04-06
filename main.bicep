param location string = resourceGroup().location

module vnetModule 'vnet.bicep'= {
  name: 'myVnet'
  params: {
    location : location
  }
}
