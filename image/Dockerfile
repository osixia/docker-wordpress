FROM osixia/baseimage:0.10.1
MAINTAINER Bertrand Gouny <bertrand.gouny@osixia.net>

## Default configuration: can be overridden at the docker command line
ENV DB_HOST database
ENV DB_NAME wordpress
ENV DB_USER wp-user
ENV DB_PASSWORD wp-password
ENV DB_TABLE_PREFIX wp_

ENV SSL_CRT_FILENAME wp.crt
ENV SSL_KEY_FILENAME wp.key

# Wordpress version
ENV WP_VERSION 4.1
ENV WP_SHA1 f0437c96ae3d8acaba3579566f1346f4cd06468e

# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

ADD service/wordpress/ssl /etc/nginx/ssl

# Enable php and nginx
RUN /sbin/enable-service php5-fpm nginx \
&& /sbin/nginx-add-vhost wordpress /var/www/wordpress --php --ssl \
--ssl-crt=/etc/nginx/ssl/$SSL_CRT_FILENAME \
--ssl-key=/etc/nginx/ssl/$SSL_KEY_FILENAME

#Download, check integrity and unzip wordpress to /var/www/wordpress
RUN curl -o wordpress.tar.gz -SL https://wordpress.org/wordpress-${WP_VERSION}.tar.gz \
	&& echo "$WP_SHA1 *wordpress.tar.gz" | sha1sum -c - \
	&& tar -xzf wordpress.tar.gz \
	&& mv wordpress /var/www \
	&& rm wordpress.tar.gz \
	&& rm -rf wordpress

ADD service/wordpress/ sbin/wordpress/

# Set wordpress directory in a data volume
VOLUME ["/var/www"]

# Expose http and https default ports
EXPOSE 80 443

# Clear out the local repository of retrieved package files
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*