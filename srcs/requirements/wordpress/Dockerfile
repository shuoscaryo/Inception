FROM alpine:3.19.2

# Install PHP, PHP-FPM, PHP-MYSQL and MariaDB-Client
RUN apk update && apk add php-fpm \
	php-phar \
	php-mysqli \
	mariadb-client \
	php-mbstring \
	php-session \
	curl

# Copy configuration files
COPY ./conf/www.conf /etc/php82/php-fpm.conf

# Copy entrypoint
COPY ./tools/WordSetUp.sh /tools/WordSetUp.sh

EXPOSE 9000

CMD ["sh", "/tools/WordSetUp.sh"]
