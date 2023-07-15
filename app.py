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
        return render_template('create_profile.html')

@app.route('/check_profile', methods=['GET', 'POST'])
def check_profile():
    if request.method == 'POST':
        data = request.form
        customer_id = data['id']

        try:
            with connection.cursor() as cursor:
                cursor.execute("SELECT * FROM users WHERE id = %s", (customer_id,))
                result = cursor.fetchone()

            if result:
                profile = {
                    'id': result[0],
                    'name': result[1],
                    'email': result[2]
                }
            else:
                profile = {}

            return render_template('CheckProfile.html', profile=profile)
        except pymysql.Error as e:
            print(f"Error accessing the database: {str(e)}")
            return jsonify({'error': 'An error occurred while accessing the database.'}), 500
        finally:
            connection.close()
    else:
        return render_template('CheckProfile.html')


if __name__ == '__main__':
    app.run(debug=True)
