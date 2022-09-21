# File to traverse a given directory and it's sub directories and retrieve all the files.
import os, argparse

# Directory to traverse 
#rootdir = sys.argv[1]

# parser
parser = argparse.ArgumentParser(
    description="Traverses a directory and builds a forensic body file",
    epilog="Developed by Dylan Navarro, 20220921"
)

# Add arguments to pass to the fs.py program
parser.add_argument("-d", "--directory", required=True, help="Directory that you want to traverse.")

# Parse the arguments
args = parser.parse_args()

rootdir = args.directory

#print(rootdir)

# In our stroy we will traverse a directory

# Check to see if the argument is a dir
if not os.path.isdir(rootdir):
    print(f"Invalid direcotry => {rootdir}")
    exit()

# List to save the files
fList = []

# craw through the provided directory
for root, subfolders, filenames in os.walk(rootdir):
    for f in filenames:
        #print(root + "\\" + f)
        fileList = root + "/" + f
        #print(fileList)
        fList.append(fileList)

#print(fList)

def statFile(toStat):
    # i is going to be the var used for each metadata element
    i = os.stat(toStat,follow_symlinks=False)
    # mode
    mode = i[0]
    # inode
    inode=i[1]
    # uid
    uid = i[4]
    # gid 
    gid = i[5]
    # file size 
    fSize = i[6]
    # access time
    aTime = i[7]
    # modification time 
    mTime = i[8]
    #ctime -> windows is the birth of the file, when it was created. Unix is when attributes of the file changes.
    cTime = i[9]
    crTime = i[9]
    print(f"0|{toStat}|{inode}|{mode}|{uid}|{gid}|{fSize}|{aTime}|{mTime}|{cTime}|{crTime}")


for eachFile in fList:
    statFile(eachFile)