FROM osixia/web-baseimage:release-1.2.0-dev

# Wordpress version
ARG WORDPRESS_VERSION=5.3
ARG WORDPRESS_MD5=b4ffcc17cbe6a6546fba4112d55e8ba5

# Install apache2 and php7.3-fpm using osixia/baseimage utils
# Caution: /container/tool/install-service-available arguments order is important
# php7.3-fpm install will detect apache2 and configure it

# Download, check integrity and unzip wordpress to /var/www/wordpress_bootstrap,
RUN apt-get update \
	&& /container/tool/add-multiple-process-stack \
	&& /container/tool/add-service-available :apache2 :php7.3-fpm :ssl-tools \
	&& LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
	ca-certificates \
	curl \
	mariadb-client \
	php7.3-apc \
	php7.3-gd \
	php7.3-ldap \
	php7.3-mysql \
	&& curl -o wordpress.tar.gz -SL https://wordpress.org/wordpress-${WORDPRESS_VERSION}.tar.gz \
	&& echo "$WORDPRESS_MD5 *wordpress.tar.gz" | md5sum -c - \
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
