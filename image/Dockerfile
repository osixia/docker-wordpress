FROM osixia/baseimage:0.10.2
MAINTAINER Bertrand Gouny <bertrand.gouny@osixia.net>

## Default configuration: can be overridden at the docker command line
ENV DB_HOST 172.17.42.1
ENV DB_NAME wordpress
ENV DB_USER wp-user
ENV DB_PASSWORD wp-password
ENV DB_TABLE_PREFIX wp_

ENV HTTPS true

# self signed certificat will be generated 
# if HTTPS is set to true and this files
# don't exists in service/wordpress/nginx/ssl
ENV SSL_CRT_FILENAME wordpress.crt
ENV SSL_KEY_FILENAME wordpress.key

# Wordpress version
ENV WORDPRESS_VERSION 4.1
ENV WORDPRESS_SHA1 f0437c96ae3d8acaba3579566f1346f4cd06468e

# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Install apache2 and php5-fpm using osixia/baseimage utils
# Caution: /sbin/enable-service arguments order is important
# php5-fpm install will detect apache2 and configure it
RUN apt-get update && /sbin/enable-service apache2 php5-fpm \
	&& LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends php5-mysql

# Download, check integrity and unzip wordpress to /var/www/wordpress
RUN curl -o wordpress.tar.gz -SL https://wordpress.org/wordpress-${WORDPRESS_VERSION}.tar.gz \
	&& echo "$WORDPRESS_SHA1 *wordpress.tar.gz" | sha1sum -c - \
	&& tar -xzf wordpress.tar.gz \
	&& mv wordpress /var/www \
	&& rm wordpress.tar.gz \
	&& rm -rf wordpress

# Add wordpress .htaccess
ADD service/wordpress/assets/.htaccess /var/www/wordpress/.htaccess

# Run install script
ADD service/install.sh /tmp/install.sh
RUN ./tmp/install.sh && rm /tmp/install.sh

# Add Wordpress container start config
ADD service/wordpress/container-start.sh /etc/my_init.d/wordpress

# Set wordpress data directory in a data volume
VOLUME ["/var/www"]

# Expose http and https default ports
EXPOSE 80 443

# Clear out the local repository of retrieved package files
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*