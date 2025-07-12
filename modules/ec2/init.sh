#!/bin/bash
cd /home/ubuntu
git clone https://github.com/WhiskersStack/PokemonWithDynamoDB.git
chown -R ubuntu:ubuntu /home/ubuntu/PokemonWithDynamoDB
echo 'if [ -n "$SSH_CONNECTION" ]; then cd ~/PokemonWithDynamoDB && python3 main.py; fi' >>/home/ubuntu/.bashrc
