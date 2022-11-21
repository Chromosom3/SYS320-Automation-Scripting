# Create command line parameters to copy a file and place it into another directory

param(
    [Parameter(Mandatory=$True)]
    [int]$reportNo,

    [Parameter(Mandatory=$True)]
    [String]$filepath
)

# Make the directory name
$reportDir = "rpt$reportNo"

# Create a directory with the report number
mkdir $reportDir

# Copy the file to the directory
Copy-Item $filepath $reportDir