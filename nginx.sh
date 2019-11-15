#!/bin/bash

# Copy nginx configs
cp pollconfig /etc/nginx/sites-available

# Create symbolic link
ln -s /etc/nginx/sites-available/pollconfig /etc/nginx/sites-enabled/pollconfig
rm /etc/nginx/sites-available/default

# Create logging dir and file
mkdir /var/log/polling
touch "/var/log/polling/access.log"

# Check nginx configs
nginx -t

# Restart nginx
systemctl restart nginx
