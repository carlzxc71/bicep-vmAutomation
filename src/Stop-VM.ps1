[CmdletBinding()]
param (
    [string] $resourceGroupName = "<Enter the RG you are working with here>"
)

$azureVMs = @(
    "bicepvm001",
    "bicepvm002"
)

$ProgressPreference="silentlyContinue"

Disable-AzContextAutosave -Scope Process
  
# Connect to Azure with system-assigned managed identity
$AzureContext = (Connect-AzAccount -Identity).context
  
# set and store context
$AzureContext = Set-AzContext -SubscriptionName $AzureContext.Subscription -DefaultProfile $AzureContext 

# Stop the VMs

foreach($VM in $azureVMs){
    Stop-AzVM -ResourceGroupName $resourceGroupName -Name $VM -Confirm:$false -Force
}