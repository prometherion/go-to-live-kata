FROM ubuntu:14.04

MAINTAINER prometherion <dario@tranchitella.eu>

# Making available add-apt-repository thanks to software-properties-common
RUN apt-get update && apt-get install -y software-properties-common python-software-properties

# Updating package list in order to download latest PHP-FPM
RUN LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php && apt-get update
RUN apt-get install -y php-fpm

EXPOSE 9000

# Installing required extensions for Wordpress
RUN apt-get install -y php-mysql php-gd php-xmlrpc php-zip php-gettext

# Clean up packages list
RUN rm -rf /var/lib/apt/lists/*

ENV MAX_UPLOAD_SIZE=20M
CMD ["php-fpm7.1", "-F", "-d", "upload_max_filesize=${MAX_UPLOAD_SIZE}", "-d", "post_max_size=${MAX_UPLOAD_SIZE}"]

# Configuration file
COPY php-fpm.conf /etc/php/7.1/fpm/php-fpm.conf
COPY www.conf /etc/php/7.1/fpm/pool.d/www.conf