#!/bin/bash

# Game setup
cd /home/ubuntu
git clone https://github.com/WhiskersStack/PokemonWithDynamoDB.git
chown -R ubuntu:ubuntu /home/ubuntu/PokemonWithDynamoDB
echo 'if [ -n "$SSH_CONNECTION" ]; then cd ~/PokemonWithDynamoDB && python3 main.py; fi' >>/home/ubuntu/.bashrc

# Ansible setup
sudo apt update -y
sudo apt install software-properties-common -y
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible -y
ansible --version
ansible-galaxy collection install community.docker
sudo apt install python3-docker  # enables better Docker support in Ansible
