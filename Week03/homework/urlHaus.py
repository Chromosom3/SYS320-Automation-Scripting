# This imports the python CSV library
# 1. https://docs.python.org/3/library/csv.html
import csv
# Fix: Added this import to fix the x = re.findall() line not having re defined.
# Imports the regular expression library.
import re

# 2. csv.reader(csvfile, delimiter='something_otherthan_a_comma')
# 3. csv.reader(csvfile, escapechar='escape_char_value')
# 4. A heredoc in python allows you to write a text block that preserves the line breaks and indintation. 

# This defines a function called ur1HausOpen that takes two parameters.
# Fix: there was a 1 instead of an l in the function name.
def urlHausOpen(filename,searchTerm):
# Fix: Changed while to with as that is what the csv documentation states.
# Fix: changed the f variable to csvfilename to help with keeping track.
# Fix: emoved filename from quotes so it pulls the variable.
    with open(filename) as csvfile:
        # Fix: Changed review to reader as that is the right method for the CSV library.
        # Fix: Also changed the value that it passes to the reader method as this is what the documentation says to do.
        # Fix: Changed == to = as == is an operator used to compare two things not set a value. 
        contents = csv.reader(csvfile)
        # Fix: Moved the for loop under the with loop as this is how the CSV documentation indicates you loop through a CSV.

        for _ in range(9):
            # https://docs.python.org/3/library/functions.html#next
            # Retrieve the next item from the iterator by calling its __next__() method.
            next(contents)

        # Fix: Removed the s from searchTerms so it is the same as the paramater passed to the function.
        # Fix: Moved the indentation over for this section so it can be interpreted correctly.
        # Fix: Swapped the keyword in searchTerm and eachLine in contents for statements.
        # This itterates through eachline in the CSV after the 9 we already skipped. 
        for eachLine in contents:
            # This itterates through each keyword in the search term list passed to the function.
            for keyword in searchTerm:
                # Fix: This is a non imported library. Had to add the import at the begining of the file.
                # Fix: Fixed the arguments section to match the requirements for findall. 
                # https://docs.python.org/3/library/re.html#re.findall
                # This does a regular expression check for the keywork in the url field of the line.
                x = re.findall(keyword,eachLine[2])
                # Fix: Moved everything below here to this indentation level or further.
                for _ in x:
                    #print(f"underscore 2: {_}")
                    # Don't edit this line. It is here to show how it is possible
                    # to remove the "tt" so programs don't convert the malicious
                    # domains to links that an be accidentally clicked on.
                    the_url = eachLine[2].replace("http","hxxp")
                    
                    # CSV Header
                    # id,dateadded,url,url_status,last_online,threat,tags,urlhaus_link,reporter
                    # Fix: changed eachLine[4] (last_online) to eachLine[7] (urlhaus_link)
                    # This sets the info src url to a variable to be printed
                    the_src = eachLine[7]
                    # Fix: Changed the string formating
                    # Prints the information about the URL and the info.
                    print(f"""
                    URL: {the_url}
                    Info: {the_src}
                    """ + "*" * 60)
                    # Fix: Changed the * print to be proper so you aren't adding a string and an int and instead are putting multiple *s.