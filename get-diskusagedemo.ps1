<#
.SYNOPSIS
This script will generate a report showing the disk utilization on the system specified.

.DESCRIPTION
This script will generate a report showing the disk utilization on the system specified.  You can sepcify the computername or 
it will choose the localohist by default.

Final Version 6/6/2019

.EXAMPLE
.\get-diskusagedemo.ps1

.EXAMPLE
.\get-diskusagedemo.ps1 -computername JWQPRDS04

.PARAMETER Computername
Not mandatory.  will be localhost by default.

.OUTPUTS
A table displayed is the conole will show the disk usage
#>
param (
  [string]$computername = 'localhost'
)
Get-WmiObject -class Win32_LogicalDisk -computername $computername `
 -filter "drivetype=3" |
 Sort-Object -property DeviceID |
 Format-Table -property DeviceID,
     @{label='FreeSpace(MB)';expression={$_.FreeSpace / 1MB -as [int]}},
     @{label='Size(GB';expression={$_.Size / 1GB -as [int]}},
     @{label='%Free';expression={$_.FreeSpace / $_.Size * 100 -as [int]}}

     