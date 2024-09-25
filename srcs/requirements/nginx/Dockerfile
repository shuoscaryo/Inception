FROM alpine:3.19.2

# Install Nginx y OpenSSL
RUN apk update && apk add nginx openssl

# Create directories
RUN mkdir -p /app /www /etc/nginx/ssl

# SSL certificate

RUN openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key -subj "/C=ES/ST=Madrid/L=Madrid/O=42/OU=42/CN=orudek.42.fr/UID=orudek"

# Copy configuration files
COPY ./config/nginx.conf /etc/nginx/nginx.conf

# Port 80 y 443
EXPOSE 80 443

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]