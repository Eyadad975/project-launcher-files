# System Info Fetch Script - PowerShell

# Get OS info
$os = Get-CimInstance Win32_OperatingSystem
# Get Computer System info
$cs = Get-CimInstance Win32_ComputerSystem
# Get CPU info
$cpu = Get-CimInstance Win32_Processor
# Get Disk info for C:
$disk = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"
# Get primary IPv4 address (non-loopback, DHCP assigned)
$ip = Get-NetIPAddress -AddressFamily IPv4 -PrefixOrigin DHCP |
      Where-Object { $_.IPAddress -ne '127.0.0.1' } |
      Select-Object -First 1 -ExpandProperty IPAddress
# Get last boot time formatted
$lastBoot = $os.LastBootUpTime.ToLocalTime().ToString('yyyy-MM-dd HH:mm:ss')

Write-Host "OS:            $($os.Caption) (Version $($os.Version))"
Write-Host "Architecture:  $($cs.SystemType)"
Write-Host "CPU:           $($cpu.Name)"
Write-Host "RAM:           $([math]::Round($cs.TotalPhysicalMemory / 1GB)) GB"
Write-Host "Disk C::       $([math]::Round($disk.FreeSpace / 1GB)) GB free / $([math]::Round($disk.Size / 1GB)) GB total"
Write-Host "Last Boot:     $lastBoot"
Write-Host "User:          $env:USERNAME"
Write-Host "PC Name:       $env:COMPUTERNAME"
Write-Host "IP Address:    $ip"
