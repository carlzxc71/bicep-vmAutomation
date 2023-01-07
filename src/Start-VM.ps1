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

# Stop the VM
# Start-AzVM -ResourceGroupName $resourceGroupName -Name $vmName -Confirm:$false

foreach($VM in $azureVMs){
    Start-AzVM -ResourceGroupName $resourceGroupName -Name $VM -Confirm:$false
}