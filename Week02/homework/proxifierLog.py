import logCheck
import importlib
importlib.reload(logCheck)

# Proxifier Events

def proxifier_open(filename,service,term):
    # Call syslogCheck and return the results

    is_found = logCheck._logs(filename,service,term)

    # found list 
    found = []

    # Loop through the results
    for eachFound in is_found:
        # Split the results
        sp_results = eachFound.split(" ")
        # sp_result values
        # ['[07.26', '19:01:00]', 'QQPlayer.exe', '-', 'btrace.qq.com:80', 'open', 'through', 'proxy', 'proxy.cse.cuhk.edu.hk:5070', 'HTTPS']
        # Append the split value to the found list
        found.append(f"{sp_results[0]}{sp_results[1]} {sp_results[2]} {sp_results[4]} {sp_results[5]} {sp_results[6]} {sp_results[7]} {sp_results[8]}")

    # Remove duplicates by using set and convert array to dictionary
    getValues = set(found)
    for eachValue in getValues:
        print(eachValue)

def proxifier_data(filename,service,term):
    # Call syslogCheck and return the results

    is_found = logCheck._logs(filename,service,term)

    # found list 
    found = []

    # Loop through the results
    for eachFound in is_found:
        # Split the results
        sp_results = eachFound.split(" ")
        # sp_results values
        # ['[07.27', '10:05:03]', 'QQProtectUpd.exe', '-', 'qdun-data.qq.com:443', 'close,', '261', 'bytes', 'sent,', '70', 'bytes', 'received,', 'lifetime', '<1', 'sec']
        # Append the split value to the found list
        found.append(f"{sp_results[2]} {sp_results[4]} {sp_results[6]} {sp_results[8]} {sp_results[9]} {sp_results[11]}")

    # Remove duplicates by using set and convert array to dictionary
    getValues = set(found)
    for eachValue in getValues:
        print(eachValue)