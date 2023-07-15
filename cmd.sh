# Set up a virtual environment
sudo apt install python3-venv

python3 -m venv venv

source venv/bin/activate

sudo apt install python3 python3-pip

pip install Flask 
# Install Gunicorn
pip install gunicorn

# Export the Flask environment variables
export FLASK_APP=app.py
export FLASK_ENV=development

# Run the Flask application with Gunicorn
gunicorn app:app -b 0.0.0.0:5000 &