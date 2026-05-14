# Setup NFS Server with Autofs client access

## Requirements:

- 2 Virtual Machine's
- VirtualBox: 2 network adapters required - NAT and host only
    - NAT - internet access
    - Host only - VM-VM communication, static networking



### Virtual Box

Instructions for both VM's
- add/update virtual network cards(virtual devices)
- Adapter 1 - NAT becomes **enpo0s3**
- Adapter 2 - Host-Only becomes **enpo0s8**


### Network

For NFS to work both machines have to be on the same **subnet ex. 192.168.56**. Configure network on both machines with respective IP's

```bash
# show available network devices

nmcli dev status
nmcli con show 

# add connection

nmcli con add con-name enp0s8 type ethernet ifname enp0s8
nmcli con mod enp0s8 ipv4.addresses 192.168.56.11/24 ipv4.method manual
# server 192.168.56.11
# client 192.168.56.10

# enable connection

nmcli con up enp0s8

# check internet and VM access

nmcli con show
ping 8.8.8.8
ping 192.168.56.10
```

### SERVER
Follow server setup in `server.sh`

### CLIENT

Follow client setup in `client.sh`

## Troubleshooting

Check:
- systemctl: status, errors
- network connection 
- firewall configurations
- SELinux: mode, context, booleans
- NFS and Autofs file mapping

```bash
# check both client & server
systemctl
journalctl

# --- network connection ---
ip a
nmcli


# --- firewall ---
firewall-cmd --list-all

# --- SELinux ---
# mode
getenforce
setenforce

# context
semanage fcontext - l | grep "{public,share}"

#booleans
getsebool | grep "{public,share}"
setsebool [boolean-name] on/off

# autofs
cat /etc/auto.master
cat /etc/auto.shares


# --- nfs ---

mount | grep nfs
df -h
```

