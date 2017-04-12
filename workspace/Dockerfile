FROM ubuntu:14.04

MAINTAINER prometherion <dario@tranchitella.eu>

# Wordpress version to install:
# check out https://it.wordpress.org/releases/ for more details
ARG WP_VERSION=4.7.3

# Dependencies for Wordpress deploy
RUN apt-get update
RUN apt-get install -y curl unzip

# Installing Wordpress into application folder
RUN mkdir /tmp/$WP_VERSION \
	&& cd /tmp/$WP_VERSION \
	&& curl -sS https://it.wordpress.org/wordpress-$WP_VERSION-it_IT.zip > $WP_VERSION.zip \
	&& unzip $WP_VERSION.zip -d /var/www

# Clean up packages list
RUN rm -rf /var/lib/apt/lists/*

# True command for volume sharing
COPY true-asm /true
RUN chmod 775 /true
CMD ["/true"]

# Defining entrypoint
COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh
ENTRYPOINT ["/sbin/entrypoint.sh"]