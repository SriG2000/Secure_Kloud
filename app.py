import pymysql
from flask import Flask, render_template, request, jsonify

app = Flask(__name__)

def get_db():
    if 'db' not in g:
        g.db = pymysql.connect(
            host='',
            user='',
            password='',
            database=''
        )
    return g.db

@app.teardown_appcontext
def close_db(error):
    db = g.pop('db', None)
    if db is not None:
        db.close()

@app.route('/')
def welcome_page():
    return render_template('WelcomePage.html')

@app.route('/create_profile', methods=['GET', 'POST'])
def create_profile():
    if request.method == 'POST':
        data = request.form
        eid = data['eid']
        name = data['name']
        email = data['email']

        db = get_db()
        with db.cursor() as cursor:
            cursor.execute("INSERT INTO users (eid, name, email) VALUES (%s, %s, %s)", (eid, name, email))
            customer_id = cursor.lastrowid
        db.commit()

        return jsonify({'id': eid, 'name': name, 'email': email})

    else:
        return render_template('CreateProfile.html')

@app.route('/check_profile', methods=['GET', 'POST'])
def check_profile():
    if request.method == 'POST':
        data = request.form
        eid = data['eid']

        try:
            db = get_db()
            with db.cursor() as cursor:
                cursor.execute("SELECT * FROM users WHERE id = %s", (eid,))
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

    else:
        return render_template('CheckProfile.html')

if __name__ == '__main__':
    app.run(debug=True)
