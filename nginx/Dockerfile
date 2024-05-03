FROM nginx:latest

COPY nginx.conf.template /etc/nginx/nginx.conf.template
COPY cert.crt /etc/nginx/ssl/cert.crt
COPY cert.key /etc/nginx/ssl/cert.key
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh
RUN mkdir -p /etc/nginx/ssl

EXPOSE 80
EXPOSE 443

ENTRYPOINT ["/entrypoint.sh"]

