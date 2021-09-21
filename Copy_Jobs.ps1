###########################################################################################
# Scenario: powershell script to copy Jobs from one server to another using dbotools Module 
# Author : Moosa Raja
# Creation Date: 21.09.2021
#  How to use this powershell script:
#    - Launch SQL Server PowerShell ( Start -> Run -> sqlps.exe)
#    - Copy the following powershell script and save to file (Ex c:\ps\Copy_logins.ps1)
#    - in SQL powershell window, type in script file path ( Ex: c:\ps\Copy_logins.ps1) to run the script
#    - or SQL powershell window, just run the .\copy_logins.ps1 and press enter. 
###########################################################################################

$Sourceserver = Read-Host "Enter Source Server Name"
$DestinationServer = Read-Host "Enter Destination Server Name"
$JobName = Read-Host "Enter Job Name to Migrate (If you leave blank, all the Jobs will be migrated"

write-host $JobName


if ($JobName -eq '')
{
	$ExcludeJobName = Read-Host "Need to exclude any jobs"
	write-host $ExcludeJobName 
	if ($ExcludeJobName -eq '')
	{
		write-host "Staring migrating of all Jobs...."
		Copy-DbaAgentJob -Source $Sourceserver -Destination $DestinationServer 
		write-host "All Jobs are Migrated Successfully"
	}
	else
	{
		write-host "Staring migrating of all Jobs excecpt"$ExcludeJobName
		Copy-DbaAgentJob -Source $Sourceserver -Destination $DestinationServer -ExcludeJob $ExcludeJobName
		write-host "All Jobs are Migrated Successfully"
	}
}
else
{
	write-host "Staring migration of Job "$JobName
	Copy-DbaAgentJob -Source $Sourceserver -Destination $DestinationServer -Job $JobName -Force
	write-host "login " $JobName " Migrated Successfully"
	
}


