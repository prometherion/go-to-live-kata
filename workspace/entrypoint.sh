#!/bin/bash

# chown and chmod according to www-data, same as nginx and php-fpm
chown -R www-data:www-data /var/www/wordpress
chmod 755 -R /var/www/wordpress
