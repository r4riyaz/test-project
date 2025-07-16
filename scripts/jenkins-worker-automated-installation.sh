#!/bin/bash
apt update
apt-get -y upgrade
apt-get -y install openjdk-21-jdk docker-ce docker-ce-cli containerd.io
systemctl enable docker.service
systemctl enable containerd.service
usermod -aG docker ubuntu
