<# 
Set up environment
Get the modules from remote repositories. 
Find-Module *ssh*
Install the desired module
Install-Module Posh-SSH (Already Installed from other project)
#>

# Connect to the remote server
$credentials = Get-Credential
$ip = '192.168.1.229'
New-SSHSession -ComputerName $ip -Credential (Get-Credential $credentials)

# while ($true) {
#     # Add a prompt to run commands
#     $command = Read-Host "Please enter a command"

#     # Run command on remote SSH server
#     (Invoke-SSHCommand -index 0 $command).Output
# }

# SCP to transfer files
Set-SCPItem -ComputerName $ip -Credential $credentials -Path "test.txt" -Destination "/home/ubuntu"

# Remove-SSHSession -SessionId 0