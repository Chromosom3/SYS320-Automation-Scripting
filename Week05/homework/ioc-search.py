# Script: ioc-search.py
# Author: Dylan 'Chromosome' Navarro
# Description: This script is designed to automate the search for indicators of compromise in log files.

# Imports
import yaml, argparse, os, csv

# Sets the information for the argparser
parser = argparse.ArgumentParser(
    description="This script is designed to automate the search for indicators of compromise in log files.",
    epilog="Developed by Dylan Navarro, 20221005"
)

# Add arguments for the script
parser.add_argument("-d", "--directory", required=True, help="Directory that you want to traverse.")
parser.add_argument("-s", "--search", required=True, help="File for searchterms.")

# Parse the arguments
args = parser.parse_args()
# Set the root directory for finding files
rootdir = args.directory
# Sets the path for the file that contains our search terms.
searchterm = args.search

def load_yaml(file):
    # This opens are YAML file
    try: 
        with open(file, 'r')  as yf:
            # Parses the data using the yaml library
            yaml_data = yaml.safe_load(yf)
    except EnvironmentError as e:
        # Returns an error if the file doesn't exist.
        print(e.strerror)
    # Lets send the data back to the variable that called this.
    return yaml_data

def get_files():
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
    # Return the list of files to the variable. 
    return fList

def file_checker(yaml_section, files):
    # Lets loop through each detection in this YAML section. 
    name = yaml_section["name"]
    print("\n\n\n" + "=" * 54 + f"Parsing Section: '{name}'" + "=" * 54)
    for detection in yaml_section["detections"]:
        # Here just for testing:
        #print(f"\nDetection {detection}\n")
        # List to store the results in an array.
        detection_results = []
        # Loop through each file in the files variable (array of file paths)
        for file in files:
            # This is here just for testing.
            #print(f"\nSearching {file}\n")
            # Lets open the CSV files. THE ENCODING PART IS NECESSARY!!!!
            with open(file, newline='',encoding='utf-8') as csv_file:
                # Use the CSV lirbary to parse the file. 
                csv_data = csv.DictReader(csv_file)
                # Lets iterate through the lines in the CSV files.
                for line in csv_data:
                    # Check to see if the detection value is in the arguments. 
                    arguments = line["arguments"]
                    if detection in arguments:
                        # If the detection is found lets get the related information
                        hostname = line["hostname"]
                        name = line["name"]
                        path = line["path"]
                        pid = line["pid"]
                        username = line["username"]
                        # Add the results to the array for results. 
                        detection_results.append("-" * 24 + f"\nHostname: {hostname}\nUsername: {username}\nName: {name}\nArguments: {arguments}\nPath: {path}\nPid: {pid}\n" + "-" * 24 )
        # Check to see if any detections were found.
        if len(detection_results) > 0: 
            # Lets get the description and the links for the YAML Section
            desc = yaml_section["description"]
            links = yaml_section["links"]
            # Print some messages about the section
            print("\n" + "*" * 54 + f"Detection(s) found for detection rule '{detection}'" + "*" * 54 + f"\n{desc}\nResources:")
            # For the sections that have multiple resource links
            for link in links:
                print(f"- {link}")
            # Just here for formating
            print("\n")
            # Lets print all the detection results.
            for item in detection_results:
                # This should create a byte string that can be read since it's encoded with UTF-8
                string = item.encode(encoding='UTF-8',errors='ignore')
                # This decodes the byte string and prints it. 
                print(string.decode("UTF-8"))
        else:
            # Inform the user no detections were found for this.
            print(f"No results found for detection rule {detection}")




def parse_yaml(yaml, files):
    for section in yaml:
        # Each section in the YAML file has name, description, links, and detections
        values = yaml[section]
        # Calls the file searching function with the information for this specific section in the YAML
        file_checker(values,files)
            

# Lets set the YAML Data to a variable
yaml_data = load_yaml(searchterm)
# Array of file paths from the get_files function.
files = get_files()

# Now lets start processing some of the data. This will loop through the YAML data.
parse_yaml(yaml_data, files)