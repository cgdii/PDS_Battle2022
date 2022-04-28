function Get-UpTime {
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
            $lastbootTime =  (Get-CimInstance win32_operatingsystem ).LastBootUpTime
            #Reduce event to time and key parts of the message 
            [psCustomObject]@{"Time"=$lastbootTime   
                              "Uptime" = [datetime]::now.Subtract($lastbootTime)}
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
        $result | Select-Object Time, Uptime | ForEach-Object {$_.pstypenames.add('Uptime') ; $_} 
    } 
}