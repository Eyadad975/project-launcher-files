$outputFile = "$PSScriptRoot\wifi_passwords.txt"
"SSID HERE | PASSWORD HERE" | Out-File -FilePath $outputFile -Encoding utf8

# Get all Wi-Fi profiles
$profiles = netsh wlan show profiles | Select-String "All User Profile" | ForEach-Object {
    ($_ -split ":")[1].Trim()
}

foreach ($ssid in $profiles) {
    $password = "N/A"
    try {
        # Try to get the clear-text key (password)
        $keyContent = netsh wlan show profile name="$ssid" key=clear | Select-String "Key Content"
        if ($keyContent) {
            $password = ($keyContent -split ":")[1].Trim()
        }
    } catch {
        $password = "N/A"
    }
    "$ssid | $password" | Out-File -FilePath $outputFile -Append -Encoding utf8
}

Write-Host "Wi-Fi profiles and passwords saved to $outputFile"
