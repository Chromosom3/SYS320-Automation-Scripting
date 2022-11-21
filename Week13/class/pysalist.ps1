# List files in the directory 
# List all files and print the full path 
#Expand-Archive .\Documents.zip

#Get-ChildItem -Recurse -Include *.docx, *.pdf, *.txt -Path .\Documents | Select-Object FullName

Get-ChildItem -Recurse -Include *.docx, *.pdf, *.txt -Path .\Documents | Export-Csv -Path files.csv

# Import the CSV
$filelist = Import-Csv -Path .\files.csv -Header FullName

# Loop through the results
foreach ($file in $filelist) {
    Get-ChildItem -Path $file.FullName
}