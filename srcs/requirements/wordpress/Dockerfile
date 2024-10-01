FROM alpine:3.19.2

# Install PHP and PHP extensions
RUN apk update && apk add php-fpm \
	php-phar \
	php-mysqli \
	mariadb-client \
	php-mbstring \
	php-session \
	curl

# Copy configuration files into the container
COPY ./conf/www.conf /etc/php82/php-fpm.conf
COPY ./tools /tools

EXPOSE 9000

CMD ["sh", "/tools/WordSetUp.sh"]
