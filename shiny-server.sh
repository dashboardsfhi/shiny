#!/bin/sh

# Make sure the directory for individual app logs exists
mkdir -p /var/log/shiny-server
chown shiny.shiny /var/log/shiny-server

echo "server{
    listen 3838 127.0.0.1;
    
    location / {
    site_dir /srv/shiny-server;
    log_dir /var/log/shiny-server;
    directory_index on;
    }
}" > /etc/shiny-server/shiny-server.conf

exec shiny-server >> /var/log/shiny-server.log 2>&1
