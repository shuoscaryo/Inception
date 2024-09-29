#!/bin/bash

# Download WP-CLI and save it as /usr/local/bin/wp so it can be used as "wp stuff"
if [ ! -f "/usr/local/bin/wp" ]; then
  curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar --silent
  chmod +x wp-cli.phar
  mv wp-cli.phar /usr/local/bin/wp
fi

# Exit if WP-CLI installation failed
if ! wp --info > /dev/null 2>&1; then
  echo "WP-CLI installation failed."
  exit 1
fi

# Wait for MySQL to be ready
while true; do
	echo "Checking connection to MySQL..."
	if mysql -u $MYSQL_USER -p$MYSQL_PASSWORD -h mariadb -e "SELECT 1;" > /dev/null;
	then
		break
	fi
	echo "Connection failed, retrying in 5 seconds..."
	sleep 5
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

echo "Wordpress setup completed!"

echo "Starting PHP-FPM..."
php-fpm82 --nodaemonize
