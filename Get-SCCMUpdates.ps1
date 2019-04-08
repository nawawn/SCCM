[CmdletBinding()]
Param(        
    [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName,Position=0)]
    [Alias('Cn')]$ComputerName        
)
 
Begin {}
Process{

    Function Test-AdminMode{
        [OutputType([Bool])]
        $IsAdmin = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
        return ($IsAdmin.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
    }

    $Property = @(
        @{n='ComputerName';e={$ComputerName}},
        'ArticleID',
        'IsUpgrade',
        'Deadline',        
        'Name',
        'URL'
    )
    
    $WmiParam = @{}
    $WmiParam.add('Class',"CCM_SoftwareUpdate")
    $WmiParam.add('Filter',"ComplianceState=0")
    $WmiParam.add('Namespace','root\CCM\ClientSDK')
    If($ComputerName){ $WmiParam.add('ComputerName',$ComputerName) }
    
    <# Uncomment this if you are running it on Console (not in scheduled task)
    Else{
        If (!(Test-AdminMode)){
            Write-Warning "PowerShell needs to run on Administrative mode!"
            return
        }
    }
    #>

    Get-WmiObject @WmiParam | Select-Object -Property $Property           
}
End { }
