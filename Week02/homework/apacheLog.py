import logCheck
import importlib
importlib.reload(logCheck)

# Apache Events

def apache_events(filename,service,term):
    # Call syslogCheck and return the results

    is_found = logCheck._logs(filename,service,term)

    # found list 
    found = []

    # Loop through the results
    for eachFound in is_found:
        # Split the results
        sp_results = eachFound.split(" ")
        # Append the split value to the found list
        found.append(sp_results[3] + " " + sp_results[0] + " " +  sp_results[1])

    # Remove duplicates by using set and convert array to dictionary
    getValues = set(found)
    for eachValue in getValues:
        print(eachValue)