describe "Our Module" {
    context "Get-DiskUsage" {
        Get-DiskUsage | Select-Object -ExpandProperty Size |Should -begreaterthan 0
    }
}
