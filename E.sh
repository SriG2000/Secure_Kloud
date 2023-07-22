#!/bin/bash
rm -rf Secure_Kloud
sudo apt-get update
sudo apt-get install python3-venv
sudo apt-get update
sudo apt-get install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker
sudo apt-get update
sudo apt-get install -y python3-venv git
git clone git@github.com:SriG2000/Secure_Kloud.git
cd Secure_Kloud
chmod +x Setup.sh && ./Setup.sh
