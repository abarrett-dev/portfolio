read -p "Enter Username:" username
echo "Username: $username"

cut -f 1 -d ":" /etc/passwd > ~/linux-server-automation/userlist.txt
user_list=~/linux-server-automation/userlist.txt

if grep -qw "$username" "$user_list"
then
	echo "User exists"
else
	echo "User does not exist"
fi

