function Get-VerInfo {
<#
  .synopsis
    Gets the last boot time and the elapsed time for the local machine or a machine at the end of a session 
   .Example 
        PS> $sess = New-PSSession -VMName octo 
        PS> Get-LastShutDown -Session $sess
   
        Creates a session and requests the uptime
    #>
    [cmdletBinding()]
    param ( 
        [Parameter(ValueFromPipeline=$true)]
        #The session for a remote machine 
        $Session
    )
    begin {
        $scriptblock  = { 
            [psCustomObject]@{ osversion   =  (Get-CimInstance win32_operatingsystem ).Version
                               sshversion  =  (Get-Command ssh).Version
                               psVersion   =  $PSVersionTable.PSVersion}
        }
    }
    process {
        if ($Session) {
            $result = foreach ($s in $session) {
                Invoke-Command -Session $S -ScriptBlock $scriptblock
            }
        }   
        else {  $result = Invoke-Command -ScriptBlock $scriptblock}
        #Strip remoting properties and add a type for formatting
        $result | Select-Object *version | ForEach-Object {$_.pstypenames.add('VersionInfo') ; $_} 
    } 
}