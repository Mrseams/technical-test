FROM php:8.2-fpm-alpine

# Install Nginx and Supervisor
RUN apk add --no-cache nginx supervisor

# Copy PHP file
WORKDIR /var/www/html
COPY index.php .

# Copy Nginx config
COPY nginx.conf /etc/nginx/nginx.conf

# Simple supervisord config
COPY supervisord.conf /etc/supervisord.conf

EXPOSE 8080

# Start both Nginx and PHP-FPM
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
