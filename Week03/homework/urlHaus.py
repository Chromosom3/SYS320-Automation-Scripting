# This imports the python CSV library
# https://docs.python.org/3/library/csv.html
import csv
# This defines a function called ur1HausOpen that takes two parameters.
def ur1HausOpen(filename,searchTerm):
# Changed while to with as that is what the csv documentation states.
# changed the f variable to csvfilename to help with keeping track.
# Removed filename from quotes so it pulls the variable.
    with open(filename) as csvfile:
        # Changed review to reader as that is the right method for the CSV library.
        # Also changed the value that it passes to the reader method as this is what the documentation says to do.
        contents == csv.reader(csvfile)
    for _ in range(9):
    next(contents)
    for keyword in searchTerms:
    for eachLine in contents:
    x = re.findall(r+keyword+,eachLine[2])
    for _ in x:
    # Don't edit this line. It is here to show how it is possible
    # to remove the "tt" so programs don't convert the malicious
    # domains to links that an be accidentally clicked on.
    the_url = eachLine[2].replace("http","hxxp")
    the_src = eachLine[4]
    print("""
    URL:
    Info: 
    {}""",format(the_url, the_src,"*"+60))