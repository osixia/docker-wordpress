FROM osixia/web-baseimage:1.1.1
MAINTAINER Bertrand Gouny <bertrand.gouny@osixia.net>

# Wordpress version
ARG WORDPRESS_VERSION=4.9.1
ARG WORDPRESS_SHA1=892d2c23b9d458ec3d44de59b753adb41012e903

# MariaDB version
ARG MARIADB_MAJOR=10.2

# Install apache2 and php7.0-fpm using osixia/baseimage utils
# Caution: /container/tool/install-service-available arguments order is important
# php7.0-fpm install will detect apache2 and configure it

# Add MariaDB repository
RUN apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xF1656F24C74CD1D8 \
    && echo "deb http://ftp.igh.cnrs.fr/pub/mariadb/repo/$MARIADB_MAJOR/debian stretch main" > /etc/apt/sources.list.d/mariadb.list \
    && { \
		     echo 'Package: *'; \
		     echo 'Pin: release o=MariaDB'; \
		     echo 'Pin-Priority: 999'; \
	     } > /etc/apt/preferences.d/mariadb

# Download, check integrity and unzip wordpress to /var/www/wordpress_bootstrap,
RUN apt-get update \
  	&& /container/tool/add-multiple-process-stack \
  	&& /container/tool/add-service-available :apache2 :php7.0-fpm :ssl-tools \
  	&& LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  		 ca-certificates \
  		 curl \
  		 mariadb-client-$MARIADB_MAJOR \
  		 php7.0-apc \
  		 php7.0-gd \
  		 php7.0-mcrypt \
  		 php7.0-mysql \
  		 php7.0-ldap \
  	&& curl -o wordpress.tar.gz -SL https://wordpress.org/wordpress-${WORDPRESS_VERSION}.tar.gz \
  	&& echo "$WORDPRESS_SHA1 *wordpress.tar.gz" | sha1sum -c - \
  	&& mkdir -p /var/www/wordpress_bootstrap /var/www/wordpress \
  	&& tar -xzf wordpress.tar.gz --strip 1 -C /var/www/wordpress_bootstrap \
  	&& apt-get remove -y --purge --auto-remove curl ca-certificates \
    && rm wordpress.tar.gz \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add service directory to /container/service
ADD service /container/service

# Use baseimage install-service script and clean all
# https://github.com/osixia/docker-light-baseimage/blob/stable/image/tool/install-service
RUN /container/tool/install-service

# Add default env variables
ADD environment /container/environment/99-default

# To persist the container files add these directories to volumes
# VOLUME ["/var/www/wordpress", "/data/backup"]

# Expose http and https default ports
EXPOSE 80 443
