#!/bin/bash

# Set up a virtual environment
sudo apt install python3-venv
python3 -m venv venv
source venv/bin/activate
sudo apt install python3 python3-pip
pip install Flask gunicorn pymysql

# MySQL database credentials
DB_HOST="localhost"
DB_USER="your_username"
DB_PASSWORD="your_password"
DB_NAME="skdb"

# SQL code to create the emp table
SQL_CODE=$(cat << EOF
CREATE DATABASE IF NOT EXISTS $DB_NAME;
USE $DB_NAME;
CREATE TABLE IF NOT EXISTS emp (
    eid INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);
EOF
)

# Log in to MySQL and execute the SQL code
mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD -e "$SQL_CODE"

# Export the Flask environment variables
export FLASK_APP=app.py
export FLASK_ENV=development

# Run the Flask application with Gunicorn
gunicorn app:app -b 0.0.0.0:5000 &
