#! /bin/bash

# Update packages and install dev tools
sudo apt update
sudo apt install python3-pip python3-dev libpq-dev postgresql git postgresql-contrib nginx curl vim

# Set up postgres database
sudo -u postgres psql -c "CREATE DATABASE sreproject"
sudo -u postgres psql -c "CREATE USER sreprojectuser WITH PASSWORD 'sreprojectpw'"
sudo -u postgres psql -c "ALTER ROLE sreprojectuser SET client_encoding TO 'utf8'"
sudo -u postgres psql -c "ALTER ROLE sreprojectuser SET default_transaction_isolation TO 'read committed'"
sudo -u postgres psql -c "ALTER ROLE sreprojectuser SET timezone TO 'UTC'"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE sreproject TO sreprojectuser"
sudo -H pip3 install --upgrade pip
sudo -H pip3 install virtualenv

# Activate python dev environment and install remaining tools
cd ~/django-polling
source pollingenv/bin/activate
sudo pip install django gunicorn psycopg2-binary

# Modify allowed hosts to include fresh vm
myIP=$(curl https://ipinfo.io/ip)
echo "ALLOWED_HOSTS = ['$myIP', 'localhost', 'bestgroupsre.ipq.co']" >> django_polling/settings.py

# Migrate db and app settings
python3 manage.py makemigrations
python3 manage.py migrate
python3 manage.py createsuperuser
sudo python3 manage.py collectstatic

# Run gunicorn server
gunicorn --bind 0.0.0.0:8000 django_polling.wsgi
