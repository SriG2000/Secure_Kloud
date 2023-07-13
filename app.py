import pymysql
from flask import Flask, render_template, request, jsonify

app = Flask(__name__)
connection = pymysql.connect(host='sqlrds.ckrzivzfkk23.us-east-2.rds.amazonaws')

@app.route('/create_profile', methods=['GET', 'POST'])
def create_profile():
    if request.method == 'POST':
        data = request.form
        name = data['name']
        email = data['email']

        with connection.cursor() as cursor:
            cursor.execute("INSERT INTO users (name, email) VALUES (%s, %s)", (name, email))
            customer_id = cursor.lastrowid

        connection.commit()

        return jsonify({'id': customer_id, 'name': name, 'email': email})
    else:
        return render_template('create_profile.html')

@app.route('/check_profile', methods=['GET', 'POST'])
def check_profile():
    if request.method == 'POST':
        data = request.form
        customer_id = data['id']

