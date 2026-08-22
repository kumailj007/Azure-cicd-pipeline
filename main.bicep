// main.bicep
// Provisions a Linux App Service to host the containerized demo app.
// Validated on every pipeline run via `az bicep build`; deployed only when the
// deploy stage is enabled (see README).

targetScope = 'resourceGroup'

@description('Azure region')
param location string = resourceGroup().location

@description('Globally-unique web app name')
param webAppName string = 'az400-demo-${uniqueString(resourceGroup().id)}'

@description('Container image to run, e.g. ghcr.io/<user>/az400-demo:<sha>. Supplied by the pipeline; no default so a deploy can never silently ship the wrong image.')
param containerImage string

var tags = {
  project: 'az400-cicd-demo'
  managedBy: 'bicep'
}

resource plan 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: 'asp-az400-demo'
  location: location
  tags: tags
  sku: {
    name: 'B1'
  }
  kind: 'linux'
  properties: {
    reserved: true
  }
}

resource webApp 'Microsoft.Web/sites@2023-12-01' = {
  name: webAppName
  location: location
  tags: tags
  properties: {
    serverFarmId: plan.id
    httpsOnly: true
    siteConfig: {
      linuxFxVersion: 'DOCKER|${containerImage}'
      appSettings: [
        {
          name: 'WEBSITES_PORT'
          value: '8000'
        }
      ]
    }
  }
}

output webAppUrl string = 'https://${webApp.properties.defaultHostName}'
