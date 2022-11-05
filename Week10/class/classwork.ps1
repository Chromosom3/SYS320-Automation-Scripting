# Get a list of running processes

# Get list of members (properties)
# Get-Process | Get-Member

# Get a list of processes with their name, id, and path
# Get-Process | Select-Object ProcessName, Id, Path

# Save output to a CSV file
# Get-Process | Select-Object ProcessName, Id, Path | Export-Csv "processes.csv"

#$outputName = "services.csv"
# System Services and properties
# Get-Service | Get-Member
# Get-Service | Select-Object Status, Name, DisplayName, BinaryPathName | Export-CSV $outputName

$outputName = "running_services.csv"
# Get a list of running services
Get-Service | Where-Object {$_.Status -eq "Running"} | Select-Object Status, Name, DisplayName, BinaryPathName | Export-CSV $outputName

# Check to see if file exists
if (Test-Path $outputName) {
    Write-Host -BackgroundColor "Green" -ForegroundColor "White" "Services file was created."
} else {
    Write-Host -BackgroundColor "Red" -ForegroundColor "White" "File not created."
}