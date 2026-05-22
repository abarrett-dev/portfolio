#!/bin/bash
project_dir=~/linux-server-automation
config_file=$project_dir/.config
log_file=$project_dir/log.txt
admin_group="systemAdmins"

mkdir -p $project_dir

echo 'Welcome to your new server!' > $log_file
echo '1. Update Package Manager'

echo 'Which package manager are you using: dnf or apt?'
read package_manager

if [[ $package_manager == 'dnf' ]]
then	
	# update package manager
	# dnf upgrade -y || echo 'Error Updating Package Manager'
	echo $package_manager >> $log_file


elif [[ $package_manager == 'apt' ]]
then 
	# apt update && apt upgrade -y || echo 'Error Updating Package Manager'
	echo $package_manager >> $log_file


else 
	echo "Invalid Package Manager. exiting Server setup" >> $log_file
	exit 0

fi



echo '2. Update Hostname'
echo 'Type Hostname:'
read hostname

echo "Are you sure you want Hostname set to:$hostname. If yes to 'y', no type 'n', cancel type 'c':"
read hostname_confirm

if [[ $hostname_confirm == 'y' ]]
then
	hostnamectl set-hostname $hostname || echo 'Error Setting Hostname.' 
	echo "Hostname set to: $hostname" >> $log_file

elif [[$hostname_confirm == 'n' ]]
then
	echo "Choose hostname:"
	read hostname

elif [[ $hostname_confirm == 'c' ]]
then
	echo "User canceled setup. Goodbye!" >> $log_file

	exit 0
fi

echo '3. Edit Hosts:'
echo Syntax Matters ex. # 192.168.1.10 foo.example.org foo
echo "1 host per line, enter additional host on a new line. When finished entering hosts type 'done'"
hosts=()
read host
osts+=($host)
while [[ $host != 'done' ]]
do
	read host
	hosts+=($host)
done
echo ${hosts[@]} >> $log_file

echo "4. Add System Administrator"
echo "Choose Username:"
read username
echo "Are you sure you want to create a username: $username ?"
echo "Type 'y' for yes , 'n' for no 'c' to cancel setup"
read username_confirm

while [[ $username_confirm != 'y' ]]
do 
	if [[ $username_confirm == 'c' ]]
	then
		exit 0
	elif [[ $username_confirm == 'n' ]]
	then
		read username
	else 
		echo "invalid choice"
		echo "Type 'y' for yes , 'n' for no 'c' to cancel setup"
		read username_confirm
	fi
done

echo $username >> $log_file

groupadd $admin_group
tail -n /etc/group

useradd -G $admin_group $username
tail -n /etc/passwd >> $log_file

echo "Create a Password for $username"
passwd $username || echo "Error creating password."
usermod -aG wheel $username

grep "wheel*" /etc/group






