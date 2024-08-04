FROM alpine:3.19.2

# Install MariaDB
RUN apk update && apk add mariadb mariadb-client

# Copy configuration files
COPY ./conf/my.cnf /etc/mysql/my.cnf
COPY ./conf/my.cnf /etc/my.cnf
COPY ./conf/mariadb-server.cnf /etc/my.cnf.d/mariadb-server.cnf

# Copy tools
COPY tools/MariaSetUp.sh /tools/MariaSetUp.sh

RUN mkdir -p /run/mysqld

RUN mkdir -p /var/lib/mysql

# Give permissions to the script
RUN chmod +x ./tools/MariaSetUp.sh

# Execute the script
CMD ["sh", "./tools/MariaSetUp.sh"]
