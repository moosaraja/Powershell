#This file is to get all DB Size in the given servers 
#Please create a folder in C: Drive as PS to execute this PS File
#Please execute this file through Admin Account

[System.Threading.Thread]::CurrentThread.CurrentCulture = New-Object "System.Globalization.CultureInfo" "en-US"

#Declare this varible to ignore the null value on the results
$sysadminResults = @()  

$instanceName = Read-host "Enter server name to check the DB Size" 
        
		write-host "Executing query against server: " $instanceName
        $sysadminResults += Invoke-Sqlcmd -InputFile "C:\PS\DBA_Check\Retrieve_Current_DB_SIZES.sql" -ServerInstance $instanceName


# Output to CSV
write-host "Here is the DB Size of " $instanceName
$sysadminResults | Format-table


