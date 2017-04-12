FROM ubuntu:14.04

MAINTAINER prometherion <dario@tranchitella.eu>

# Installing MySQL Server
RUN apt-get update
RUN apt-get install -y mysql-server

EXPOSE 3306

# Database environment variables used in entrypoint
ENV MYSQL_DATABASE=wordpress
ENV MYSQL_USER=wordpress
ENV MYSQL_PASSWORD=w0rdpr355
ENV MYSQL_CHARSET=utf8
ENV MYSQL_COLLATION=utf8_unicode_ci

# Defining entrypoint
COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh
ENTRYPOINT ["/sbin/entrypoint.sh"]

CMD ["/usr/bin/mysqld_safe"]

VOLUME /var/lib/mysql