import syslogCheck
import importlib
importlib.reload(syslogCheck)

# SSH Successful Authentication
# This script will look through a log file and print out any user that successfully SSHed into this system.
# Sample log line:
# sshd(pam_unix)[19432]: session opened for user test by (uid=509)

def ssh_success(filename, searchTerms):
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
    users = set(found)
    for eachUser in users:
        print(eachUser)