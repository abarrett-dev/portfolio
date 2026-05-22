# Docker Engine Installation

**Docker Engine** is the background service that actually runs containers.

Images -  standalone package that contains everything needed to run a software application: code, runtime, libraries, environment variables, and configuration files
Containers -  a live, isolated process that actually executes images
Volumes - persistent storage, lives outside the container


1. Remove unofficial packages
2. Install Docker
3. Verify Installation

```bash

#Remove unofficial packages
sudo apt remove $(dpkg --get-selections docker.io docker-compose docker-doc podman-docker containerd runc | cut -f1)

# Optional -- Images, containers, volumes, or custom configuration files on your host aren't automatically removed. To delete all images, containers, and volumes:

sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/containerd


sudo apt update

# Add Docker's official GPG key:
sudo apt update
sudo apt install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/debian
Suites: $(. /etc/os-release && echo "$VERSION_CODENAME")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

sudo apt update

sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo systemctl status docker

sudo systemctl start docker

# verify
sudo docker run hello-world
```

Resources

https://docs.docker.com/engine/install/debian/