#!/usr/bin/env bash

set -ex
set -o pipefail

## install docker on Ubuntu
if grep -q -i ubuntu /etc/os-release; then
    ## install docker using convenience script https://docs.docker.com/engine/install/ubuntu/
    curl -fsSL https://get.docker.com | sudo bash

fi

## install docker as per Rocky Linux docs https://docs.rockylinux.org/gemstones/containers/docker/
if grep -q -i rocky /etc/os-release; then
    sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    sudo dnf -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin
fi

## https://docs.docker.com/engine/install/linux-postinstall/
sudo groupadd docker -f
sudo usermod -aG docker $USER

## Configure Docker to start on boot with systemd
sudo systemctl enable --now docker.service
sudo systemctl enable --now containerd.service
