#!/bin/bash
sudo su -
cp ../home/bbelen/django-polling/pollconfig /etc/nginx/sites-available
ln -s /etc/nginx/sites-available/pollconfig /etc/nginx/sites-enabled/pollconfig
rm /etc/nginx/sites-enabled/default
nginx -t
systemctl restart nginx
