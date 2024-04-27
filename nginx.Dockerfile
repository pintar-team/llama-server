FROM nginx:latest

RUN apt-get update && apt-get install -y curl

COPY nginx.conf /etc/nginx/nginx.conf
COPY cloudflare.crt /etc/nginx/certs/cloudflare.crt
COPY cloudflare.key /etc/nginx/certs/cloudflare.key

ENV AUTH_TOKEN your_auth_token

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]

