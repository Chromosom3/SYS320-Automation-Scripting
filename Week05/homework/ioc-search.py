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

rootdir = args.directory
searchterm = args.search

def load_yaml(file):
    try: 
        with open(file, 'r')  as yf:
            yaml_data = yaml.safe_load(yf)
    except EnvironmentError as e:
        print(e.strerror)
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
    return fList

def file_checker(yaml_section, files):
    for detection in yaml_section["detections"]:
        print(f"\nDetection {detection}\n")
        for file in files:
            print(f"\nSearching {file}\n")
            # List to store the results
            detection_results = []
            with open(file, newline='',encoding='utf-8') as csv_file:
                csv_data = csv.DictReader(csv_file)
                for line in csv_data:
                    arguments = line["arguments"]
                    if detection in arguments:
                        hostname = line["hostname"]
                        name = line["name"]
                        path = line["path"]
                        pid = line["pid"]
                        username = line["username"]
                        detection_results.append(f"Arguments: {arguments}\nHostname: {hostname}\nName: {name}\nPath: {path}\nPid: {pid}\nUsername: {username}")
    if len(detection_results) > 0: 
        print(detection_results)




def parse_yaml(yaml, files):
    for section in yaml:
        values = yaml[section]
        file_checker(values,files)
            

yamal_data = load_yaml(searchterm)
files = get_files()

parse_yaml(yamal_data, files)