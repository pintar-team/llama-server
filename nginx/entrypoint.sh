#!/bin/sh

# Substitute environment variables
envsubst < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf
# Start Nginx in the foreground
exec nginx -g 'daemon off;'
