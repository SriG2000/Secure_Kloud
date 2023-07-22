# Use an official Python runtime as a parent image
FROM python:3.8

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install required packages
RUN apt-get update \
    && apt-get install -y default-libmysqlclient-dev build-essential \
    && python3 -m venv venv \
    && . venv/bin/activate \
    && pip install Flask gunicorn pymysql

# Make port 5000 available to the world outside this container
EXPOSE 5000

# Define environment variables
ENV FLASK_APP=app.py
ENV FLASK_ENV=development

# Run gunicorn when the container launches
CMD ["gunicorn", "app:app", "-b", "0.0.0.0:5000"]
