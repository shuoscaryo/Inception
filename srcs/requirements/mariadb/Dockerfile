FROM alpine:3.19.2

# Install MariaDB
RUN apk update && apk add mariadb mariadb-client

# Copy configuration files
COPY ./conf/my.cnf /etc/my.cnf

# Copy tools
COPY tools/MariaSetUp.sh /tools/MariaSetUp.sh

RUN mkdir -p /var/lib/mysql

# Execute the script
CMD ["sh", "/tools/MariaSetUp.sh"]
