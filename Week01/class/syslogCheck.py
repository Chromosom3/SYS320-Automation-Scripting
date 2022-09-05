#Create an interface to search through a syslog file.
import re, sys
from unittest import result

def _syslog(filename,listOfKeywords):
    # Open a file
    with open(filename) as f:
        # Read the file and save it to a variable
        contents = f.readlines()
    
    # List to store the results
    results = []

    # Loop through the contents variable. Each element is a line from the log file.
    for line in contents:
        # Loop through the keywords
        for eachKeyword in listOfKeywords:
            # If the line contains the keyword then it will print the line.
            #if eachKeyword in line:
            # Searches and returns results using a regular expression search
            x = re.findall(r""+eachKeyword+"", line)
            #print(x)
            for found in x: 
                # Addpend the returned keywords to the results list
                results.append(found)


    # Check to see if there are results 
    if len(results) == 0:
        print("No Results")
        sys.exit(1)

    # Sort the list
    results = sorted(results)
            
    return results