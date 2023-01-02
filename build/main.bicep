// PARAMETERS

param location string = resourceGroup().location
param workload string = 'vmautomation'
param env string = 'dev'

// MODULES

module automationAccountModule 'modules/automationAccount.bicep' = {
  name: 'deployAutomationAccount'
  params: {
    location: location
    env: env
    workload: workload
  }
}

