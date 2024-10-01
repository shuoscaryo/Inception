#!/bin/bash

# Check if required environment variables are set
if [ -z "$MYSQL_DATABASE" ] || [ -z "$MYSQL_USER" ] \
	|| [ -z "$MYSQL_PASSWORD" ] || [ -z "$ADMIN_USER" ] \
	|| [ -z "$ADMIN_PASSWORD" ] || [ -z "$ADMIN_EMAIL" ] \
	|| [ -z "$WORDPRESS_USER" ] || [ -z "$WORDPRESS_PASSWORD" ] \
	|| [ -z "$WORDPRESS_EMAIL" ] || [ -z "$DOMAIN_NAME" ]; then
	echo "Missing required environment variables"
	sleep 5
	exit 1
fi

# Check if users contain words "admin" or "administrator" in case insensitive way
if [[ "$ADMIN_USER" =~ [Aa][Dd][Mm][Ii][Nn] ]] || [[ "$WORDPRESS_USER" =~ [Aa][Dd][Mm][Ii][Nn] ]]; then
	echo "Usernames cannot contain 'admin' or 'administrator'"
	sleep 5
	exit 1
fi

# Download WP-CLI and save it as /usr/local/bin/wp so it can be used as "wp stuff"
if [ ! -f "/usr/local/bin/wp" ]; then
	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar --silent
	chmod +x wp-cli.phar
	mv wp-cli.phar /usr/local/bin/wp
fi

# Exit if WP-CLI installation failed
if ! wp --info > /dev/null 2>&1; then
	echo "WP-CLI installation failed."
	sleep 5
	exit 1
fi

# Wait for MySQL to be ready
i=1
while [ $i -le 11 ]; do
    if mysql -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" -h mariadb -e "SELECT 1;" &> /dev/null; then
        break
    fi
    if [ $i -eq 11 ]; then
        echo "Connection to MySQL failed."
        sleep 5
        exit 1
    fi
    echo "Attempt $i Connection failed, retrying in 5 seconds..."
    sleep 5
    i=$((i + 1))
done

echo "Connection to MySQL established!"

# Wordpress setup
# Delete the default wp-config.php file even if has been created by another docker container 
rm -rf /wordpress/wp-config.php
mkdir -p /wordpress /wordpress/wp-content/uploads
chmod -R 755 /wordpress
cd /wordpress
wp core download
wp config create --dbname="$MYSQL_DATABASE" --dbuser="$MYSQL_USER" --dbpass="$MYSQL_PASSWORD" --dbhost=mariadb
wp core install --url="$DOMAIN_NAME" --title=Inception --admin_user="$ADMIN_USER" --admin_password="$ADMIN_PASSWORD" --admin_email="$ADMIN_EMAIL"
wp theme install --activate hello-elementor
wp user create "$WORDPRESS_USER" "$WORDPRESS_EMAIL" --role=author --user_pass="$WORDPRESS_PASSWORD"
wp plugin install elementor --activate
cp /tools/no-admin-or-administrator.php /wordpress/wp-content/plugins/
wp plugin activate no-admin-or-administrator

echo "Wordpress setup completed!"

echo "Starting PHP-FPM..."
php-fpm82 --nodaemonize
