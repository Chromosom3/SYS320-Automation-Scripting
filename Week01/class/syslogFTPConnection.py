import syslogCheck
import importlib
importlib.reload(syslogCheck)

# FTP connection viewing
# This script is used to search the log files for any FTP connections and prints the host that made the FTP connection.


def ftp_connect(filename, searchTerms):
    # Call syslogCheck and return the results

    is_found = syslogCheck._syslog(filename,searchTerms)

    # found list 
    found = []

    # Loop through the results
    for eachFound in is_found:
        # Split the results
        sp_results = eachFound.split(" ")
        # Append the split value to the found list
        found.append(sp_results[3])

    # Remove duplicates by using set and convert array to dictionary
    hosts = set(found)
    for eachHost in hosts:
        print(eachHost)