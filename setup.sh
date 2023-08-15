#!/bin/bash

# For ubuntu 22.04

# Update the package repository and upgrade existing packages
sudo apt-get update -y
sudo apt-get upgrade -y

# Install Docker
sudo apt-get install -y docker.io

# Start and enable Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Install Jenkins

sudo apt update
yes | sudo apt install openjdk-17-jre
yes | curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
yes | echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
yes | sudo apt-get install jenkins

# Start and enable Jenkins service
# Open port 8080
sudo ufw allow 8080
# Enable UFW 
sudo ufw enable
# Restart serice 
sudo systemctl restart jenkins.service



