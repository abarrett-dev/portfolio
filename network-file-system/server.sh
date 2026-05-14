#!/bin/bash

# install nfs packages

dnf install nfs*

# start and enable nfs service

systemctl status nfs-server
systemctl enable --now nfs-server
systemctl status nfs-server

# create shared directory

mkdir -p /share
chmod 777 /share

# edit nfs config

vi /etc/exports
/share 192.168.56.10(rw,sync) # single client rw
#/share *(rw,sync) # allows anyone to rw
#/share 192.168.56.x(rw,sync) # all clients rw

# reload and esport all shares

exportfs -avr

# add firewall rules 

firewall-cmd --permanent --add-service={nfs,mountd,rpc-bind}
firewall-cmd --reload
firewall-cmd --list-all

# test nfs connection

cat /etc/exports
exports -v
ip a