#!/bin/bash
docker_path=$(which docker)
docker_compose_path=$(which docker-compose)

if [ "$docker_path" == "/usr/bin/docker" ]; then
    echo "Docker is already installed."
else
    echo "Docker is not installed. Installing Docker..."
    sudo apt-get update
    sudo apt-get install -y docker.io
    sudo systemctl start docker
    sudo systemctl enable docker
    echo "Docker installed successfully!"

fi


if [ "$docker_compose_path" == "/usr/bin/docker-compose" ]; then
    echo "Docker Compose is already installed."

else
    echo "Docker Compose is not installed. Installing Docker Compose..."
    sudo apt-get update
    sudo apt-get install -y docker-compose
    echo "Docker Compose installed successfully!"

fi
