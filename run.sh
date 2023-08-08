#!/bin/bash

pids=$(sudo fuser -n tcp 5000 2>/dev/null)
for pid in $pids; do
    sudo kill $pid
done
sudo apt-get update
sudo apt-get install -y git python3 python3-pip

python3 -m venv venv
source venv/bin/activate

sudo apt install python3 python3-pip
pip install Flask pymysql
sudo apt install mysql-client-core-8.0   

cd Secure_Kloud

export FLASK_APP=app.py
export FLASK_ENV=production
nohup flask run --host=0.0.0.0 &

