#! /bin/sh

if [ -z "$MYSQL_DATABASE" ] || [ -z "$MYSQL_USER" ] \
	|| [ -z "$MYSQL_PASSWORD" ] || [ -z "$MYSQL_ROOT_PASSWORD" ]; then
	echo "Missing required environment variables"
	sleep 5
	exit 1
fi

chown -R mysql: /var/lib/mysql
chmod 777 /var/lib/mysql

echo "Installing MariaDB..."
mysql_install_db --skip-test-db >/dev/null 2>&1

if [ ! -d "/var/lib/mysql/$MYSQL_DATABASE" ]; then
	echo "CREATE DATABASE \`$MYSQL_DATABASE\`;
CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON \`$MYSQL_DATABASE\`.* TO '$MYSQL_USER'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
FLUSH PRIVILEGES;" > "/tmp/init.sql"
	echo "Starting MariDB server..."
  	mysqld_safe --init-file="/tmp/init.sql" >/dev/null 2>&1
else
	echo "Starting MariDB server..."
	mysqld_safe >/dev/null 2>&1
fi