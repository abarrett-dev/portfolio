#!/usr/bin/bash

# This script uses ssh to connect to a remote server, execute a shell script to backup files, including sqlite3 databases files. Once backup is complee it uses scp to copy the backup file from the remote server to the local machine. Finally it runs a restore script to extract the backup files.

# Make sure the file is executable: chmod +x retrieve.sh
# Usage: ./retrieve.sh

# Note: Before running the script, make sure to update the variables at the top of the script with the correct paths and names for your project.

# Depengind on your remote and local OS you may need to adjust the scp and ssh commands for compatibility. For example, on windows you may need to use a different syntax for file paths and may need to use a different tool for ssh and scp, such as PuTTY or WinSCP. This set up is for a linux to linux environment, but can be adjusted for windows with the appropriate syntax changes.

REMOTE_SERVER="username@hostname" # replace with your remote server username and hostname/ip address

BACKUP_FILE_NAME="compressed_archive_name" # replace with the name of your backup file, should correspond to the name used in the backup script

BACKUP_DIR="/tmp/backup_test" # replace with the directory on the remote server where the backup file is stored

RESTORE_DIR="/path/to/restore_dir" # replace with the path to the directory where you want to restore the files on the local machine

BACKUP_SCRIPT_NAME="/path/to/backup.sh" # replace with the path to the backup script on the remote server

RESTORE_SCRIPT_NAME="/path/to/restore.sh" # replace with the path to the restore script on the local machine

# Connect to the remote server and execute the backup script, if it fails print error message
ssh $REMOTE_SERVER "$BACKUP_SCRIPT_NAME" || echo "Error occurred while executing backup script on remote server. Please check the file path and name."

# copy newest backup file from remote server to local machine
NEWEST=$(ssh $REMOTE_SERVER "ls -t $BACKUP_DIR/$BACKUP_FILE_NAME-*.tar.gz | head -1")

# securely copy the newest backup file from the remote server to the local machine, if it fails print error message
scp "$REMOTE_SERVER:$NEWEST" "$RESTORE_DIR" || echo "Error occurred while copying backup file from remote server to local machine. Please check the file paths and names."

# run the restore script to extract the backup file
./$RESTORE_SCRIPT_NAME || echo "Error occurred while executing restore script. Please check the file path and name."

