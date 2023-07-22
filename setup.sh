#!/bin/bashrm 
sudo apt-get update
sudo apt-get install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker
sudo apt-get update
sudo apt-get install -y python3-venv git

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
mysql_host='skdb.csdmbmuvmujj.us-east-2.rds.amazonaws.com'
mysql_user='admin'
mysql_password='srivatsav'
mysql_db='skdb'

# Use here-doc syntax to pass multi-line SQL commands to the MySQL client
mysql -h $mysql_host -u $mysql_user -p$mysql_password << EOF
CREATE DATABASE IF NOT EXISTS $mysql_db;
USE $mysql_db;
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    email VARCHAR(255)
);
EOF
gunicorn app:app -b 0.0.0.0:5000 &
docker build -t my_flask_app .
docker run -d -p 5000:5000 my_flask_app


