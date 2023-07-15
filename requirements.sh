#!/bin/bash

# Update the package manager and install Git
sudo apt update
sudo apt install -y git

# Install Python and pip
sudo apt install -y python3 python3-pip

# Install python3-venv
sudo apt install -y python3-venv

# Create and activate the virtual environment
python3 -m venv venv
source venv/bin/activate

# Install Flask
pip3 install flask

# Install pymysql
sudo apt install -y default-libmysqlclient-dev
pip3 install pymysql
sudo apt install -y mysql-client-core-8.0

# Install nginx
sudo apt install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx

# Configure nginx
sudo rm /etc/nginx/sites-enabled/default
sudo touch /etc/nginx/sites-available/flask-app
sudo ln -s /etc/nginx/sites-available/flask-app /etc/nginx/sites-enabled/flask-app
sudo bash -c 'cat > /etc/nginx/sites-available/flask-app <<EOF
server {
    listen 80;
    server_name ec2-3-135-249-213.us-east-2.compute.amazonaws.com;

    location / {
        proxy_pass http://localhost:5000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
EOF'

sudo systemctl restart nginx

# Install Gunicorn
pip3 install gunicorn

# Activate the virtual environment
source venv/bin/activate

# Set Flask environment variables
export FLASK_APP=app.py
export FLASK_ENV=development

# Launch the application with Gunicorn
gunicorn app:app -b 0.0.0.0:5000
