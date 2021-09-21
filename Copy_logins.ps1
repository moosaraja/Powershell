###########################################################################################
# Scenario: powershell script to copy logins from one server to another using dbotools Module 
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
$LoginName = Read-Host "Enter Login Name to Migrate (If you leave blank, all the logins will be migrated"
write-host $LoginName 

if ($LoginName -eq '')
{
	write-host "Staring migrating of all logins, except the system Logins...."
	Copy-DbaLogin -Source $Sourceserver -Destination $DestinationServer -ExcludeSystemLogins
	write-host "All logins Migrated Successfully"
}
else
{
	write-host "Staring migration for login "$LoginName
	Copy-DbaLogin -Source $Sourceserver -Destination $DestinationServer -login $LoginName -Force
	write-host "login " $LoginName " Migrated Successfully"
	
}


