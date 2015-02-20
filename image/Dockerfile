FROM osixia/baseimage:0.10.2
MAINTAINER Bertrand Gouny <bertrand.gouny@osixia.net>

# Wordpress version
ENV WORDPRESS_VERSION 4.1.1
ENV WORDPRESS_SHA1 15d38fe6c73121a20e63ccd8070153b89b2de6a9

# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Install apache2 and php5-fpm using osixia/baseimage utils
# Caution: /sbin/enable-service arguments order is important
# php5-fpm install will detect apache2 and configure it

# Download, check integrity and unzip wordpress to /var/www/wordpress,
RUN apt-get update && /sbin/enable-service apache2 php5-fpm ssl-kit \
	&& LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends php5-mysql php-apc php5-mcrypt php5-gd \
	&& curl -o wordpress.tar.gz -SL https://wordpress.org/wordpress-${WORDPRESS_VERSION}.tar.gz \
	&& echo "$WORDPRESS_SHA1 *wordpress.tar.gz" | sha1sum -c - \
	&& mkdir -p /var/www/wordpress \
	&& tar -xzf wordpress.tar.gz --strip 1 -C /var/www/wordpress

# Add install script and wordpress assets
ADD service/install.sh /tmp/install.sh
ADD service/wordpress/assets /osixia/wordpress

# Run install script and clean all
RUN ./tmp/install.sh && rm /tmp/install.sh \
	&& rm wordpress.tar.gz \
	&& apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add default env variables
ADD env.yml /etc/env.yml

# Add Wordpress container start config
ADD service/wordpress/container-start.sh /etc/my_init.d/wordpress

# Set wordpress data directory in a data volume
VOLUME ["/var/www"]

# Expose http and https default ports
EXPOSE 80 443