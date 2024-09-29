#! /bin/sh

chown -R mysql: /var/lib/mysql
chmod 755 /var/lib/mysql

echo "Installing MariaDB..."
mysql_install_db >/dev/null 2>&1

if [ ! -d "/var/lib/mysql/$MYSQL_DATABASE" ]; then
	echo "CREATE DATABASE \`$MYSQL_DATABASE\`;
CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON \`$MYSQL_DATABASE\`.* TO '$MYSQL_USER'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
FLUSH PRIVILEGES;" > "$MYSQL_INIT_FILE"
	echo "Starting MariDB server..."
  	mysqld_safe --init-file="$MYSQL_INIT_FILE" >/dev/null 2>&1
else
	echo "Starting MariDB server..."
	mysqld_safe >/dev/null 2>&1
fi