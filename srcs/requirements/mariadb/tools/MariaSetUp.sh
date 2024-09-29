#! /bin/sh

function add_query_line {
  echo "$1" >> "$MYSQL_INIT_FILE"
}

chown -R mysql: /var/lib/mysql
chmod 777 /var/lib/mysql

mysql_install_db >/dev/null 2>&1

if [ ! -d "/var/lib/mysql/$MYSQL_DATABASE" ]; then
	echo "CREATE DATABASE $MYSQL_DATABASE;
CREATE USER $MYSQL_USER@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
CREATE USER $MYSQL_USER@'localhost' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO $MYSQL_USER@'%' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO $MYSQL_USER@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;
DROP USER 'root'@'localhost';
CREATE USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;" > $MYSQL_INIT_FILE
  echo "Starting MariDB server..."
  mysqld_safe --init-file=$MYSQL_INIT_FILE >/dev/null 2>&1
else
  echo "Starting MariDB server..."
  mysqld_safe >/dev/null 2>&1
fi