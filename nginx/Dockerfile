FROM nginx:latest

# Pass the NGINX_SECRET as a build argument
ARG NGINX_SECRET

# Copy the SSL certificates
COPY cert.crt /etc/nginx/ssl/cert.crt
COPY cert.key /etc/nginx/ssl/cert.key

# Ensure the SSL directory exists
RUN mkdir -p /etc/nginx/ssl

# Copy the Nginx configuration template
COPY nginx.conf.template /etc/nginx/nginx.conf.template

# Replace the placeholder with the actual secret
RUN sed -i "s/NGINX_SECRET_PLACEHOLDER/${NGINX_SECRET}/g" /etc/nginx/nginx.conf.template \
    && mv /etc/nginx/nginx.conf.template /etc/nginx/nginx.conf

EXPOSE 80
EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
