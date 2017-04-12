FROM ubuntu:14.04

MAINTAINER prometherion <dario@tranchitella.eu>

# Installing NGINX
RUN apt-get update
RUN apt-get install -y nginx

# Clean up packages list
RUN rm -rf /var/lib/apt/lists/*

# Forwarding access log and error log to Docker collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
	ln -sf /dev/stderr /var/log/nginx/error.log

EXPOSE 80

CMD ["nginx"]

# vhost and nginx configuration
COPY default.conf /etc/nginx/sites-enabled/default
COPY nginx.conf /etc/nginx/nginx.conf