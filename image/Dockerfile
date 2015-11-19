FROM osixia/web-baseimage:0.1.5
MAINTAINER Bertrand Gouny <bertrand.gouny@osixia.net>

# Wordpress version
ENV WORDPRESS_VERSION 4.3.1
ENV WORDPRESS_SHA1 b2e5652a6d2333cabe7b37459362a3e5b8b66221

# Use baseimage's init system.
# https://github.com/osixia/docker-light-baseimage/blob/stable/image/tool/run
CMD ["/container/tool/run"]

# Install apache2 and php5-fpm using osixia/baseimage utils
# Caution: /sbin/enable-service arguments order is important
# php5-fpm install will detect apache2 and configure it

# Download, check integrity and unzip wordpress to /var/www/wordpress_bootstrap,
RUN apt-get update \
	&& /container/tool/install-multiple-process-stack \
	&& /container/tool/install-service-available apache2 php5-fpm ssl-helper-openssl \
	&& LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
		 php5-mysql \
		 php-apc \
		 php5-mcrypt \
		 php5-gd \
	&& curl -o wordpress.tar.gz -SL https://wordpress.org/wordpress-${WORDPRESS_VERSION}.tar.gz \
	&& echo "$WORDPRESS_SHA1 *wordpress.tar.gz" | sha1sum -c - \
	&& mkdir -p /var/www/wordpress_bootstrap /var/www/wordpress \
	&& tar -xzf wordpress.tar.gz --strip 1 -C /var/www/wordpress_bootstrap

# Add service directory to /container/service
ADD service /container/service

# Use baseimage install-service script and clean all
# https://github.com/osixia/docker-light-baseimage/blob/stable/image/tool/install-service
RUN /container/tool/install-service \
		&& rm wordpress.tar.gz \
		&& apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add default env variables
ADD env.yaml /container/environment/env.yaml

# Add Wordpress container start config
ADD service/wordpress/container-start.sh /etc/my_init.d/wordpress

# Set wordpress data directory in a data volume
VOLUME ["/var/www/wordpress"]

# Expose http and https default ports
EXPOSE 80 443
