#! /usr/bin/bash

# This script will be used to create a shared directory for a group of users. The script will create a group called "halloween" and add three users to the group. The script will then create a shared directory called "/home/halloween" and set the permissions so that only members of the "halloween" group can access the directory. The script will also set the permissions so that any files created in the shared directory will be owned by the group and have read and write permissions for the group. Also users can only delete files created by themselves. Finally, the script will clean up by deleting the users and group created for this exercise.

# Make sure the file is executable: chmod +x shared-directory.sh
# Usage: ./shared-directory.sh

# create group
groupadd halloween

# Add three users to group, without passwords and add them to them to halloween group without deleting them from any other groups.
useradd ghost
passwd -d ghost
usermod -aG halloween ghost

useradd dexter
passwd -d dexter
usermod -aG halloween dexter

useradd cinderella
passwd -d cinderella
usermod -aG halloween cinderella

# check users are created 
tail -n 3 /etc/passwd > new_users.txt

# ensure users are in the group - theres many ways to this, this is one of them. and i will redirect the output to a file for later reference.
tail -n 3 /etc/group > halloween_group.txt

# create shared directory
mkdir /home/halloween

# check permissions of the shared directory and redirect the output to a file for later reference
ls -ld /home/halloween > shared_dir_permissions.txt

# change directory ownership to the group
chgrp -R halloween /home/halloween

# set directroy permissions so the halloween group has read, write and execute permisisons
chmod -R g+rwX /home/halloween

# check permissions of the shared directory and redirect the output to a file to observe changes
ls -ld /home/halloween > shared_dir_permissions_after.txt

# searching specified directory for subdirectories and setting the setgid bit on them  so users can only delete files they created and not files created by other users
find /home/halloween -type d -exec chmod g+s {} \;

# check permissions of the shared directory and redirect the output to a file to observe changes
ls -ld /home/halloween > shared_dir_permissions_final.txt

# delete users and group created for this exercise and append the output to a file for later reference, use append instead of overwrite to keep the previous outputs in the file for reference.
userdel ghost >> new_users.txt
userdel dexter >> new_users.txt
userdel cinderella >> new_users.txt
groupdel halloween >> halloween_group.txt

