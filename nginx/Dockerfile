FROM nginx:latest

COPY nginx.conf /etc/nginx/nginx.conf
COPY cert.crt /etc/nginx/ssl/cert.crt
COPY cert.key /etc/nginx/ssl/cert.key

EXPOSE 80
EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]

