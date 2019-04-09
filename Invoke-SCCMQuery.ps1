<#
.Synopsis
   Run the Query on SCCM Server
.DESCRIPTION
   Run the WMI query on SCCM Server with the given SELECT STATEMENT query
.EXAMPLE
   $Query = Select * From SMS_R_System
   Invoke-SCCMQuery -SiteName 'CM1' -ServerName SCCMSrv -Query $Query
.EXAMPLE
   $Query = Select DISTINCT From SMS_G_System_ADD_REMOVE_PROGRAMS
   Invoke-SCCMQuery -SiteName 'CM1' -ServerName SCCMSrv -Query $Query
.EXAMPLE
   $Query = Select * From SMS_Device
   Invoke-SCCMQuery -SiteName 'CM1' -ServerName SCCMSrv -Query $Query
.EXAMPLE   
   $WQLquery = @"
   SELECT SMS_R_System.Name 
   FROM SMS_R_System inner join SMS_G_System_PRINTER_DEVICE 
   ON SMS_G_System_PRINTER_DEVICE.ResourceID = SMS_R_System.ResourceId 
   WHERE SMS_G_System_PRINTER_DEVICE.PortName like "10.10.10.10"
"@
   Invoke-SCCMQuery -SiteName 'CM1' -ServerName SCCMSrv -Query $WQLquery
#>

[CmdletBinding()]
Param(
    $SiteName,
    $ServerName,
    $Query
)

$NameSpace = "root/SMS/Site_" + $SiteName
Get-WmiObject -Namespace $NameSpace -ComputerName $ServerName -Query $Query
