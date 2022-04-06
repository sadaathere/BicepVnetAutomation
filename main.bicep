param location string = resourceGroup().location

module vnetModule 'vnet.bicep'= {
  name: 'myVnet01'
  params: {
    location : location
  }
}
