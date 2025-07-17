#!/bin/bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
    gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get -y upgrade
apt-get -y install openjdk-21-jdk docker-ce docker-ce-cli containerd.io git-all
systemctl enable docker.service
systemctl enable containerd.service
usermod -aG docker ubuntu
