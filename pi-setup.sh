#!/bin/bash

echo "Initializing pi..."

# Update software

# Install gpio
if ! command -v gpio &> /dev/null
then
    wget https://project-downloads.drogon.net/wiringpi-latest.deb
    dpkg -i wiringpi-latest.deb
    apt --fix-broken install -y
fi

# Install docker
if ! command -v docker &> /dev/null
then
    apt-get update -y
    apt-get install -y \
        ca-certificates \
        curl \
        gnupg \
        lsb-release

    mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null


    apt-get update -y

    apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
fi

# Install docker-compose
if ! command -v docker-compose &> /dev/null
then
    apt install -y libffi-dev libssl-dev
    apt install -y python3-dev
    apt install -y python3 python3-pip
    pip3 install docker-compose
fi



# Setup sudo raspi-config

# https://github.com/deconz-community/deconz-docker#configuring-raspbian-for-raspbee
echo 'dtoverlay=pi3-miniuart-bt' | sudo tee -a /boot/config.txt

shutdown --reboot -h now