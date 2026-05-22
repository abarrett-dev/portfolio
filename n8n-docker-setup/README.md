# n8n Installation Guide

Requirements

* docker engine
* docker compose

Container name: n8n
Image: docker.n8n.io/n8nio/n8n:latest
Port mapping: 5678:5678
Restart policy: project_name
Compose file: docker-compose.yml
Env file: .env

**Note:** understand docker run vs. docker compose

```bash
#create volume
docker volume create n8n_data

#start container - tests container, with flags
docker run -it --rm \
 --name n8n \
 -p 5678:5678 \
 -e GENERIC_TIMEZONE="<YOUR_TIMEZONE>" \
 -e TZ="<YOUR_TIMEZONE>" \
 -e N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true \
 -e N8N_RUNNERS_ENABLED=true \
 -v n8n_data:/home/node/.n8n \
 docker.n8n.io/n8nio/n8n

# OR -- docker compose - run setup in project dir YAML file
docker compose up -d

#update n8n

# Pull latest (stable) version
docker pull docker.n8n.io/n8nio/n8n

# Pull specific version
docker pull docker.n8n.io/n8nio/n8n:1.81.0

# Pull next (unstable) version
docker pull docker.n8n.io/n8nio/n8n:next

# Find your container ID
docker ps -a

# Stop the container with the `<container_id>`
docker stop <container_id>

# Remove the container with the `<container_id>`
docker rm <container_id>

# Start the container
docker run --name=<container_name> [options] -d docker.n8n.io/n8nio/n8n

# --- update n8n - docker compose

# Navigate to the directory containing your docker compose file
cd </path/to/your/compose/file/directory>

# Pull latest version
docker compose pull

# Stop and remove older version
docker compose down

# Start the container
docker compose up -d
```

Resources

https://docs.n8n.io/hosting/installation/docker/