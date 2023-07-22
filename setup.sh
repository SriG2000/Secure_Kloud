#!/bin/bash
rm -rf Secure_Kloud
sudo apt-get update
sudo apt-get install python3-venv
git clone git@github.com:SriG2000/Secure_Kloud.git
cd Secure_Kloud

pids=$(sudo fuser -n tcp 5000 2>/dev/null)
for pid in $pids; do
    sudo kill $pid
done

sudo apt install python3-venv
python3 -m venv venv
source venv/bin/activate
sudo apt install python3 python3-pip
pip install Flask gunicorn pymysql
sudo apt install mysql-client-core-8.0   
export FLASK_APP=app.py
export FLASK_ENV=development
gunicorn app:app -b 0.0.0.0:5000 &
