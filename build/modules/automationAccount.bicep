// PARAMETERS

param location string = resourceGroup().location
param workload string = ''
param env string = ''
param currentDate string = utcNow('yyyy-MM-dd')

// VARIABLES

var deploymentTags = {
  createdBy: 'Bicep deployment'
  environtment: env
  deploymentDate: currentDate
  workload: workload
}

// RESOURCES

resource automationAccount 'Microsoft.Automation/automationAccounts@2022-08-08' = {
  name: 'aa-${workload}-${env}-001'
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  tags: deploymentTags
  properties: {
    publicNetworkAccess: false
    disableLocalAuth: false
    encryption: {
      keySource: 'Microsoft.Automation'
    }
    sku: {
      name: 'Basic'
    }
  }
}

resource automationRunbookStartVM 'Microsoft.Automation/automationAccounts/runbooks@2019-06-01' = {
  name: 'Start-VM'
  parent: automationAccount
  location: location
  properties: {
    runbookType: 'PowerShell7'
  }
  tags: deploymentTags
}

resource automationRunbookStopVM 'Microsoft.Automation/automationAccounts/runbooks@2019-06-01' = {
  name: 'Stop-VM'
  parent: automationAccount
  location: location
  properties: {
    runbookType: 'PowerShell7'
  }
  tags: deploymentTags
}

resource vmContributorRoleDefinition 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  scope: subscription()
  name: '9980e02c-c2be-4d73-94e8-173b1dc7cf3c'
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, automationAccount.id, vmContributorRoleDefinition.id)
  scope: resourceGroup()
  properties: {
    principalId: automationAccount.identity.principalId
    roleDefinitionId: vmContributorRoleDefinition.id
    principalType: 'ServicePrincipal'
  }
}
