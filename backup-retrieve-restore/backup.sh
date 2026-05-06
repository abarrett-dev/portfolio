#! /usr/bin/bash

# This script will be used to backup my project using tar and gzip. It will backup the following:
# - project files (excluding cache, logs, etc.)
# - database files
# - requirements.txt
# - include/exclude.txt
# - .service files

# This project displays my understanding of bash scripting, to automate the backup process. I declare variables and arrays to store file paths and names, and use loops and conditionals to handle the backup process. Using tar and gzip I compress files to save space and improve transfer speed between machines. I also use find to manage old backup files and ensure that the backup directory does not get cluttered with old files.I also use error handling to ensure that the script runs smoothly even if some files are missing or if there are issues with the backup process.

# Make sure the file is executable: chmod +x backup.sh
# Usage: ./backup.sh
# Note: Before running the script, make sure to update the variables at the top of the script with the correct paths and names for your project.

PROJECT_FOLDER="project_folder_name" # replace with your project folder name
SOURCE_DIR=$HOME/$PROJECT_FOLDER
DEST_DIR="/tmp/backup_test"
DATE=$(date +%F-%H%M%S)
BACKUP_FILE="$DEST_DIR/$PROJECT_FOLDER-$DATE.tar"
EXCLUDE_FILE="$SOURCE_DIR/backup-excludes.txt"
INCLUDES_FILE="$SOURCE_DIR/backup-includes.txt"
REQUIREMENTS_FILE="$SOURCE_DIR/requirements.txt"
ADMIN_SERVICE_FILES_DIR=/path/to/admin/service/files # replace with the actual path to your admin service files
USER_SERVICE_FILES_DIR=/path/to/user/service/files # replace with the actual path to your user service files
# Database files to backup


# User created Service files to backup
SERVICE_FILES_DIR=$SOURCE_DIR/service-files


DB_FILES=(
    "$SOURCE_DIR/path/to/database1.db"
    "$SOURCE_DIR/path/to/database2.db"
    "$SOURCE_DIR/path/to/database3.db"
    #"$SOURCE_DIR/path/to/does_not_exist.db" this is for testing error handling when file does not exist

)

DB_NAMES=(database1 database2 database3) # names to use for the backup files in the archive, should correspond to the DB_FILES array

# i could have used key value pairs for files and names. i will propably swith in the future



echo "Starting backup process..."
echo "Source: $SOURCE_DIR"

mkdir -p "$DEST_DIR"

# looking for backup files older than 7 days to delete from $DEST_DIR. if older than 7 days files deleted, if no files or an error and error message is printed. 
find "$DEST_DIR" -type f -name "$PROJECT_FOLDER-*.tar.gz" -mtime +7 -delete || echo "No old backup files to delete or error occurred while deleting old backups"

# backup python environment requirements and append command output to requirements.txt
$PROJECT_FOLDER/.venv/bin/python -m pip freeze > "$REQUIREMENTS_FILE"

rm -rf "$SERVICE_FILES_DIR"
mkdir -p "$SERVICE_FILES_DIR"

# find all .service files in
find "$USER_SERVICE_FILES_DIR" -name "*.service" -exec cp {} "$SERVICE_FILES_DIR" \; || echo "No service files found or error occurred while copying service files"

# using file globbbing to copy admin service files with specific file names
cp "$ADMIN_SERVICE_FILES_DIR"/{service1,service2,service3,service4}.service "$SERVICE_FILES_DIR"/ || echo "Error occurred while copying admin service files. Please check the file paths and names."


#cat $INCLUDES_FILE 
#cat $EXCLUDE_FILE
ls - "$SERVICE_FILES_DIR"

# dry run to see what files would be included but no archive file created.
tar -cvf /dev/null --exclude-from="$EXCLUDE_FILE" -C "$HOME" $PROJECT_FOLDER > $INCLUDES_FILE

#! archive only dont compress yet so i can still add stuff like db backups to the archive before compressing it. tar -czf will not work with --append (-r) so i have to do it in two steps: first create uncompressed archive,  add db files, then compress it.

# created uncompressd archive from project folder
tar -cf "$BACKUP_FILE" --exclude-from="$EXCLUDE_FILE" -C "$HOME/" $PROJECT_FOLDER

#for each database file in DB_FILES array i will run checks using if else statements to check the files existence, and integrity before backaing up db files. If everythign checks out db files are added to the archive. If there are any issues I use error handling to print messages. Once all db files have been added to the archive the last step is to compress the archive:

for i in "${!DB_FILES[@]}"; do
    # print name and location. use -e to ensure newlines are interpreted correctly
    echo -e "Name:${DB_NAMES[i]}\nLocation:${DB_FILES[i]}"

    # check file exists
    if [[ -f ${DB_FILES[i]}  ]]
	then
		echo "File exists"

        #backup databse file using sqlite command not cp to ensure data integrity
        sqlite3 "${DB_FILES[i]}" ".backup $DEST_DIR/${DB_NAMES[i]}-$DATE-backup.db"

        # check if backup file was created successfully
        if [[ -f "$DEST_DIR/${DB_NAMES[i]}-$DATE-backup.db" ]]
        then
            echo "Backup successful: $DEST_DIR/${DB_NAMES[i]}-$DATE-backup.db"
            
            #check backup
            sqlite3 "$DEST_DIR/${DB_NAMES[i]}-$DATE-backup.db" "PRAGMA integrity_check;" | head -n 1 || echo "Error: Integrity check failed"

            # add uncompressed backup to archive created earlier
            tar -rf "$BACKUP_FILE" -C "$DEST_DIR" "${DB_NAMES[i]}-$DATE-backup.db" || echo "Error: Failed to add file to archive"

            echo "Added ${DB_NAMES[i]}-$DATE-backup.db to archive"

            # remove temporary backup file
            rm "$DEST_DIR/${DB_NAMES[i]}-$DATE-backup.db" || echo "Error: Failed to remove temporary backup file"

        else
            echo "Backup failed for ${DB_NAMES[i]}"
        fi
        
    else
	    echo "File does not exist"
    fi
done

echo "Compressing backup archive..."

# compress the archive
gzip -f "$BACKUP_FILE" || echo "Error: Failed to compress archive"

# list contents of the compressed archive
tar -tf "$BACKUP_FILE.gz"
echo "Compressed backup: $BACKUP_FILE.gz"


