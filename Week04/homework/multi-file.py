# This traverses a given directory and it's sub directories and searches all log files for keyterms
import os, argparse, yaml,re,sys

# Sets the information for the argparser
parser = argparse.ArgumentParser(
    description="Traverses a directory and builds a forensic body file",
    epilog="Developed by Dylan Navarro, 20220921"
)

# Add arguments for the script
parser.add_argument("-d", "--directory", required=True, help="Directory that you want to traverse.")
parser.add_argument("-s", "--search", required=True, help="File for searchterms.")

# Parse the arguments
args = parser.parse_args()

rootdir = args.directory
searchterm = args.search

# Check to see if the directory argument is actually a directory
if not os.path.isdir(rootdir):
    print(f"Invalid direcotry => {rootdir}")
    exit()

# List to save the files
fList = []

# craw through the provided directory
for root, subfolders, filenames in os.walk(rootdir):
    for f in filenames:
        fileList = root + "\\" + f
        fList.append(fileList)

# Open the Yaml File
try: 
    with open('searchTerms.yaml', 'r')  as yf:
        keywords = yaml.safe_load(yf)
except EnvironmentError as e:
    print(e.strerror)

def _logs(file):
    
    # Query the yaml file  for  the term and retrieve the search strings
    terms = keywords["search"][searchterm]

    # Split the string  into an array.
    listOfKeywords = terms.split(",")

    with open(file) as f:
        # Read the file and save it to a variable
        contents = f.readlines()
    
    # List to store the results
    results = []

    # Loop through the contents variable. Each element is a line from the log file.
    for line in contents:
        # Loop through the keywords
        for eachKeyword in listOfKeywords:
            # Searches and returns results using a regular expression search
            x = re.findall(r""+eachKeyword+"", line)
            for found in x: 
                # Addpend the returned keywords to the results list
                results.append(found)


    # Check to see if there are results 
    if len(results) == 0:
        print("No Results")
        sys.exit(1)

    # Sort the list
    results = sorted(results)
            
    for item in results:
        print(item)



for eachFile in fList:
    print("*" * 64 + f"\nFile: {eachFile} \n" + "*" * 64 )
    result = _logs(eachFile)