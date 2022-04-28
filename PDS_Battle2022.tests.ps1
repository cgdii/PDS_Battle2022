describe "Our Module" {
    it "Get-DiskUsage" {        
        Get-DiskUsage | Select-Object -ExpandProperty Size |Should -begreaterthan 0
    }

    it 'Gets uptime' {
        Get-upTime | 
            Select-Object -expand Uptime | 
            Select-object -expand Totalseconds | 
            Should -BeGreaterthan 1
    }
}
