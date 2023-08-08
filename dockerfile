# Use the official Python image as the base image
FROM python:3.8-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the requirements file and install dependencies
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

# Copy the rest of the application files
COPY . .

# Set environment variables
ENV FLASK_APP=app.py
ENV FLASK_ENV=production

# Expose the port that Flask is running on
EXPOSE 5000

# Run the Flask application using gunicorn
CMD ["gunicorn", "app:app", "-b", "0.0.0.0:5000"]
