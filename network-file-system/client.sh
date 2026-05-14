#!/bin/bash

# check network connection
ip a

# check mount availability

showmount -e 192.168.56.11

# mount

mount -v -t nfs 192.168.56.11:/share /mnt/testnfs

# access shared directory

ls /mnt/testnfs

# unmount shared directory

umount /mnt/testnfs
```


# --- Autofs Setup ---
dnf install nfs-utils autofs
showmount -e 192.168.56.11

vi /etc/auto.master
# /misc /etc/auto.misc
/shares /etc/auto.shares

mkdir -p /shares

vi /etc/auto.shares
access      -rw,soft,intr    192.168.56.11:/share

systemctl enable --now autofs

ls /shares/access