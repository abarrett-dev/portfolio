#! /usr/bin/bash

# This script extracts files from a compressed backup file using tar and gzip.

# This project displays my understaing of bash scripting, file compression, and error handling. I use variables to store file paths and names, and use conditionals to check if the backup file exists before attempting to extract it. I also use tar with the -xvzf options to extract the files while listing the files being extracted, providing feedback on the restoration process.

# Make sure the file is executable: chmod +x restore.sh
# Usage: chmod u+x restore.sh

# Note: Before running the script, make sure to update the variables at the top of the script with the correct paths and names for your project.

RESTORE_DIR="/path/to/restore_dir" # replace with the path to the directory where you want to restore the files

# create the restore directory if it does not exist
mkdir -p "$RESTORE_DIR"

# change to the restore directory, if it fails print error message and exit with status 1
cd "$RESTORE_DIR" || exit 1


# NEWEST variable stores - newest backup file from list in specified directory
NEWEST=$(ls -t $HOME/path/to/compressed_archive_name-*.tar.gz | head -1)

# i could have used find to get the newest file, i will probably switch to find in the future for better performance and reliability.

# assign the newest backup file to the BACKUP_FILE variable
BACKUP_FILE="$NEWEST"

#check if the backup file exists
if [[ ! -f $BACKUP_FILE ]]
then 
    echo "File does not exist: $BACKUP_FILE"
    exit 1
fi

# Extract(decompress) the backup file, while listing the files being exported
tar -xvzf "$BACKUP_FILE"


echo "Restoration complete. Restored files are in: $RESTORE_DIR"