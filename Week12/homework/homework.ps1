# This script is designed to create firewall rules and copy them to a remote target. 

# Array of websites to parse for threat intell
$urls = @('https://rules.emergingthreats.net/blockrules/emerging-botcc.rules','https://rules.emergingthreats.net/blockrules/compromised-ips.txt')

# loop through the URLs for the info
foreach ($url in $urls) {
    # Extract the filename
    $file = "threat-intell/$($url.split("/")[-1])"

    if (Test-Path $file) {
       continue 
    } else {
        # Download the remote files
        Invoke-WebRequest -Uri $url -OutFile $file
    }
}

# array with files
$input_paths = @('threat-intell/emerging-botcc.rules','threat-intell/compromised-ips.txt')

# Extract IP address
$regex = '\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b'
Select-String -Path $input_paths -Pattern $regex | `
ForEach-Object {$_.Matches.Value} | Get-Unique | Out-File "threat-intell/bad-ip.txt"

function IPTables {
    if (Test-Path $outfile) {
        $choice = Read-Host "Output file already exists, do you want to delete it and create a new file [Y/n]"
        if ($choice.ToLower() -eq "y"){
            Remove-Item -Path $outfile
        } else {
            exit
        }
     }
    # Create IP Tables Rules
    # iptables -A INPUT -s IP -j DROP
    # % is the same as For-Eachobject
    (Get-Content -Path "threat-intell/bad-ip.txt") | ForEach-Object {$_ -replace "^","iptables -A INPUT -s " -replace "$", " -j DROP"} | `
    Out-File $outfile
    Set-SCPItem -ComputerName $ip -Credential $credentials -Path $outfile -Destination "~"
}

function WindowsFirewall {
    if (Test-Path $outfile) {
        $choice = Read-Host "Output file already exists, do you want to delete it and create a new file [Y/n]"
        if ($choice.ToLower() -eq "y"){
            Remove-Item -Path $outfile
        } else {
            exit
        }
     }
    # Create IP Tables Rules
    # iptables -A INPUT -s IP -j DROP
    # % is the same as For-Eachobject
    $inbound = 'New-NetFirewallRule -DisplayName "Navarro Automation" -Direction Inbound -LocalPort Any -Protocol TCP -Action Block -RemoteAddress '
    $outbound = 'New-NetFirewallRule -DisplayName "Navarro Automation" -Direction Outbound -LocalPort Any -Protocol TCP -Action Block -RemoteAddress '
    (Get-Content -Path "threat-intell/bad-ip.txt") | ForEach-Object {$_ -replace "^","$inbound"} | `
    Out-File $outfile
    (Get-Content -Path "threat-intell/bad-ip.txt") | ForEach-Object {$_ -replace "^","$outbound"} | `
    Out-File -Append $outfile
    Set-SCPItem -ComputerName $ip -Credential $credentials -Path $outfile -Destination "~"
}


# This is reused from some PowerCLI scripts I was working on
function Menu {
    try {
        [uint16]$selection = Read-Host("[1] Windows Firewall`n[2] IP Tables`nSelection")
    } catch {
        Write-Host("Bad user... Invalid selection. Must be an integer.")
    }
    
    switch ($selection)
    {
        1 {$outfile = "threat-intell/bad-ip.windows.ps1";WindowsFirewall}
        2 {$outfile = "threat-intell/bad-ip.iptables.sh";IPTables}
        19 {exit}
    }
}

# Calls the menu
$credentials = Get-Credential
$ip = '192.168.1.229'
New-SSHSession -ComputerName $ip -Credential (Get-Credential $credentials)
Menu


<#
Reflection:

1. What did you like the most and least about this assignment?
A) I like that we are in PowerShell. I also like how this is applicable to the real world.


2. What additional questions do you have?
A) No additional questions.

#>