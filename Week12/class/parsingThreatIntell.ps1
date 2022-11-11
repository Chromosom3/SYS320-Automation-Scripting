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

# Create IP Tables Rules
# iptables -A INPUT -s IP -j DROP
# % is the same as For-Eachobject
(Get-Content -Path "threat-intell/bad-ip.txt") | % {$_ -replace "^","iptables -A INPUT -s " -replace "$", " -j DROP"} | `
Out-File "threat-intell/bad-ip.iptables"
# ^ begining of line $ end of line.