# Send an email using PowerShell

$toSend = @("dunston@champlain.edu","ston@champlain.edu","duns@champlain.edu")

$msg = "Hello"
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
