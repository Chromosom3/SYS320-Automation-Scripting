import syslogCheck
import importlib
importlib.reload(syslogCheck)

# SU Open Logs
# This script is used to print out each instance of an SU log in the log file. 

def su_open(filename, searchTerms):
    # Call syslogCheck and return the results

    is_found = syslogCheck._syslog(filename,searchTerms)

    # found list 
    found = []

    # Loop through the results
    for eachFound in is_found:
        # Split the results
        sp_results = eachFound.split(" ")
        # Append the split value to the found list
        found.append(sp_results[5])

    # Remove duplicates by using set and convert array to dictionary
    returnedValues = set(found)
    for eachValue in returnedValues:
        print(eachValue)