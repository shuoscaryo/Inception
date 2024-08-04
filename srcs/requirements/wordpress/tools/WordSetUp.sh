#!/bin/bash

# install wordpress cli
if [ ! -f "/usr/local/bin/wp" ]; then
  curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar --silent
  chmod +x wp-cli.phar
  mv wp-cli.phar /usr/local/bin/wp
fi

# Verify WP-CLI installation
if ! wp --info > /dev/null 2>&1; then
  echo "WP-CLI installation failed."
  exit 1
fi

while true; do
	echo "Checking connection to MySQL..."
	if mysql -u $MYSQL_USER -p$MYSQL_PASSWORD -h $MYSQL_HOST -e "SELECT 1;"
	then
		break
	fi
	echo "Connection failed, retrying in 5 seconds..."
	sleep 5
done

echo "Connection to MySQL established!"

# Wordpress setup

if [ -f /wordpress/wp-config.php ]; then
  rm /wordpress/wp-config.php
  echo "Wordpress config file already exists, removing it..."
fi

if [ ! -f /wordpress/wp-config.php ]; then

  mkdir -p /wordpress

  chmod -R 755 /wordpress

  cd wordpress

  wp core download --path=/wordpress

  wp config create --path=/wordpress --dbname=$MYSQL_DATABASE --dbuser=$MYSQL_USER --dbpass=$MYSQL_PASSWORD --dbhost=$MYSQL_HOST

  wp core install --url=$DOMAIN_NAME --title=Inception --admin_user=$ADMIN_USER --admin_password=$ADMIN_PASSWORD --admin_email="$ADMIN_EMAIL" --path=/wordpress

  wp theme install --activate twentytwentyfour --path=/wordpress

  wp user create $WORDPRESS_USER $WORDPRESS_EMAIL --role=author --user_pass=$WORDPRESS_PASSWORD --path=/wordpress

  wp plugin install elementor --activate


  echo "Wordpress setup completed!"
fi

echo "Starting PHP-FPM..."
php-fpm82 --nodaemonize