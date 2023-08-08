import mysql.connector
from flask import Flask, render_template, request, redirect, url_for

app = Flask(__name__)

# Replace the following variables with your MySQL database credentials
hostname = 'db.csdmbmuvmujj.us-east-2.rds.amazonaws.com'
username = 'admin'
password = 'srivatsav'
database = 'SKDB'

def create_connection():
    return mysql.connector.connect(
        host=hostname,
        user=username,
        password=password,
        database=database
    )

@app.route('/')
def welcome():
    return render_template('welcome.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']

        conn = create_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM users WHERE email=%s", (email,))
        user_data = cursor.fetchone()
        conn.close()

        if user_data and user_data[4] == password:
            return redirect(url_for('dashboard', name=user_data[1]))  # Redirect to dashboard with the user's name
        else:
            return "Invalid email or password"
    return render_template('login.html')

@app.route('/signup', methods=['GET', 'POST'])
def signup():
    if request.method == 'POST':
        name = request.form['name']
        email = request.form['email']
        password = request.form['password']

        conn = create_connection()
        cursor = conn.cursor()
        try:
            cursor.execute("INSERT INTO users (name, email, password) VALUES (%s, %s, %s)", (name, email, password))
            conn.commit()
            conn.close()
            return redirect(url_for('login'))  # Redirect to login page after successful signup
        except mysql.connector.IntegrityError:
            conn.close()
            return "Error: Email already exists. Please choose another."

    return render_template('signup.html')

@app.route('/dashboard/<name>')
def dashboard(name):
    return render_template('dashboard.html', name=name)

if __name__ == '__main__':
    app.run(debug=True)
