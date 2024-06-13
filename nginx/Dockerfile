FROM nginx:latest

# Pass the NGINX_SECRET, ENABLE_LLAMA, and ENABLE_SD as build arguments
ARG NGINX_SECRET
ARG ENABLE_LLAMA
ARG ENABLE_SD

# Ensure the SSL directory exists
RUN mkdir -p /etc/nginx/ssl

# Copy the SSL certificates
COPY cert.crt /etc/nginx/ssl/cert.crt
COPY cert.key /etc/nginx/ssl/cert.key

# Copy the Nginx configuration templates
COPY nginx.conf /etc/nginx/nginx.conf

# Copy the Nginx service configurations templates
COPY llama.conf.template /etc/nginx/conf.d/llama.conf.template
COPY sd.conf.template /etc/nginx/conf.d/sd.conf.template

# Copy the Nginx upstream configurations
COPY llama.upstream.conf /etc/nginx/conf.d/llama.upstream.conf
COPY sd.upstream.conf /etc/nginx/conf.d/sd.upstream.conf

# Generate llama.conf based on ENABLE_LLAMA
RUN if [ "${ENABLE_LLAMA}" = "true" ]; then \
        sed -i "s/NGINX_SECRET_PLACEHOLDER/${NGINX_SECRET}/g" /etc/nginx/conf.d/llama.conf.template && \
        mv /etc/nginx/conf.d/llama.conf.template /etc/nginx/conf.d/llama.conf; \
    else \
        echo "# Llama service is disabled" > /etc/nginx/conf.d/llama.conf; \
        echo "# Llama upstream is disabled" > /etc/nginx/conf.d/llama.upstream.conf; \
    fi

# Generate sd.conf based on ENABLE_SD
RUN if [ "${ENABLE_SD}" = "true" ]; then \
        sed -i "s/NGINX_SECRET_PLACEHOLDER/${NGINX_SECRET}/g" /etc/nginx/conf.d/sd.conf.template && \
        mv /etc/nginx/conf.d/sd.conf.template /etc/nginx/conf.d/sd.conf; \
    else \
        echo "# SD service is disabled" > /etc/nginx/conf.d/sd.conf; \
        echo "# SD upstream is disabled" > /etc/nginx/conf.d/sd.upstream.conf; \
    fi

# Print the final configurations
RUN cat /etc/nginx/nginx.conf && cat /etc/nginx/conf.d/llama.conf && cat /etc/nginx/conf.d/sd.conf

EXPOSE 80
EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
