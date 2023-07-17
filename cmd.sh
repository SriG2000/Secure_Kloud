#!/bin/bash

# Set up a virtual environment
sudo apt install python3-venv
python3 -m venv venv
source venv/bin/activate
sudo apt install python3 python3-pip
pip install Flask gunicorn pymysql
sudo apt install mysql-client-core-8.0   
export FLASK_APP=app.py
export FLASK_ENV=development
gunicorn app:app -b 0.0.0.0:5000 &
