import syslogCheck
import importlib
importlib.reload(syslogCheck)

# Klogind Authentication Failures
# This script will look through a log file and print out any host that failed to authenticate to klogind.
# Sample log line:
# klogind[19272]: Authentication failed from 163.27.187.39 (163.27.187.39): Permission denied in replay cache code

def klogind_fail(filename, searchTerms):
    # Call syslogCheck and return the results

    is_found = syslogCheck._syslog(filename,searchTerms)

    # found list 
    found = []

    # Loop through the results
    for eachFound in is_found:
        # Split the results
        sp_results = eachFound.split(" ")
        # Append the split value to the found list
        found.append(sp_results[4])

    # Remove duplicates by using set and convert array to dictionary
    hosts = set(found)
    for eachHost in hosts:
        print(eachHost)