using namespace System.Net
# Input bindings are passed in via param block.
param($Timer)

Set-AzContext -SubscriptionId "0c3517fa-65fd-4eaf-abad-bc021baf2987"
$Resourcename = "Resource group"

$vms = Get-AzVM -ResourceGroupName $Resourcename -Status

$vms | ForEach-Object -Parallel {
   if ($_.PowerState -eq 'VM running'){
      Stop-AzVM -Name $_.Name -ResourceGroupName $_.ResourceGroupName -Confirm:$false -Force
      Write-Warning "Stop VM - $($_.Name)"
   }
   elseif ($_.PowerState -eq 'VM deallocated') {
      Write-Warning "I could not Start VM - $($_.Name) because it is currently running"
   }
   Start-Sleep 1
} -ThrottleLimit 10 #Number of VM's
