Server 1

ssh -i C:\Users\sriva\Downloads\SKF_1.pem ubuntu@ec2-3-135-249-213.us-east-2.compute.amazonaws.com

Server 2

ssh -i C:\Users\sriva\Downloads\SK_2.pem ubuntu@ec2-18-118-217-66.us-east-2.compute.amazonaws.com

code:
import pymysql
from flask import Flask, render_template, request, jsonify

app = Flask(__name__)
connection = pymysql.connect(
    host='sqlrds.ckrzivzfkk23.us-east-2.rds.amazonaws.com',
    user='srivatsav',
    password='srivatsav',
    database='SKP1'
)

@app.route('/')
def welcome_page():
    return render_template('WelcomePage.html')

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
        
        # Close the database connection
        connection.close()

        return jsonify({'id': customer_id, 'name': name, 'email': email})
    else:
        return render_template('CreateProfile.html')

@app.route('/check_profile', methods=['GET', 'POST'])
def check_profile():
    if request.method == 'POST':
        data = request.form
        customer_id = data['id']

        with connection.cursor() as cursor:
            cursor.execute("SELECT * FROM users WHERE id = %s", (customer_id,))
            result = cursor.fetchone()

        # Close the database connection
        connection.close()

        if result:
            # Fetch the profile information from the database
            # You can access the data using result[0], result[1], etc.
            profile = {
                'id': result[0],
                'name': result[1],
                'email': result[2]
            }
        else:
            profile = {}

        return render_template('CheckProfile.html', profile=profile)
    else:
        return render_template('CheckProfile.html')

if __name__ == '__main__':
    app.run(debug=True)
