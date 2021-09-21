$server = Read-Host "Enter Server Name"
Get-WmiObject win32_operatingsystem -ComputerName $server | select csname, @{LABEL='LastBootUpTime';EXPRESSION={$_.ConverttoDateTime($_.lastbootuptime)}}
