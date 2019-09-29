#!/bin/bash -e
# this script is run during the container start

# set -x (bash debug) if log level is trace
# https://github.com/osixia/docker-light-baseimage/blob/stable/image/tool/log-helper
log-helper level eq trace && set -x

FIRST_START_DONE="${CONTAINER_STATE_DIR}/docker-wordpress-first-start-done"

#
# HTTPS config
#
if [ "${WORDPRESS_HTTPS,,}" == "true" ]; then

  log-helper info "Set apache2 https config..."

  # generate a certificate and key if files don't exists
  # https://github.com/osixia/docker-light-baseimage/blob/stable/image/service-available/:ssl-tools/assets/tool/ssl-helper
  ssl-helper "${WORDPRESS_SSL_HELPER_PREFIX}" "${CONTAINER_SERVICE_DIR}/wordpress/assets/apache2/certs/$WORDPRESS_SSL_CRT_FILENAME" "${CONTAINER_SERVICE_DIR}/wordpress/assets/apache2/certs/$WORDPRESS_SSL_KEY_FILENAME" "${CONTAINER_SERVICE_DIR}/wordpress/assets/apache2/certs/$WORDPRESS_SSL_CA_CRT_FILENAME"

  # add CA certificat config if CA cert exists
  if [ -e "${CONTAINER_SERVICE_DIR}/wordpress/assets/apache2/certs/$WORDPRESS_SSL_CA_CRT_FILENAME" ]; then
    sed -i "s/#SSLCACertificateFile/SSLCACertificateFile/g" "${CONTAINER_SERVICE_DIR}/wordpress/assets/apache2/https.conf"
  fi

  ln -sf "${CONTAINER_SERVICE_DIR}/wordpress/assets/apache2/https.conf" /etc/apache2/sites-available/wordpress.conf
#
# HTTP config
#
else
  log-helper info "Set apache2 http config..."
  ln -sf "${CONTAINER_SERVICE_DIR}/wordpress/assets/apache2/http.conf" /etc/apache2/sites-available/wordpress.conf
fi

if [ "${WORDPRESS_DISABLE_XMLRPC,,}" == "true" ]; then
  sed -i --follow-symlinks "s/#disablexmlrpc//g" /etc/apache2/sites-available/wordpress.conf
fi

a2ensite wordpress | log-helper debug

#
# Wordpress directory is empty, we use the bootstrap
#
if [ ! "$(ls -A -I lost+found /var/www/wordpress)" ]; then

  log-helper info "Bootstap Wordpress..."

  mkdir -p /var/www/wordpress
  cp -R /var/www/wordpress_bootstrap/* /var/www/wordpress

  if [ "${WORDPRESS_REMOVE_DEFAULT_THEMES}" = "true" ]; then
    rm -rf /var/www/wordpress/wp-content/themes/*
  fi

  if [ "${WORDPRESS_REMOVE_DEFAULT_PLUGINS}" = "true" ]; then
    rm -rf /var/www/wordpress/wp-content/plugins/*
  fi

fi

# remove bootstrap directory
rm -rf /var/www/wordpress_bootstrap

# install plugins and themes
cp --remove-destination -Rf "${CONTAINER_SERVICE_DIR}"/wordpress/assets/wp-content/. /var/www/wordpress/wp-content

# if there is no config
if [ ! -e "/var/www/wordpress/wp-config.php" ] && [ -e "${CONTAINER_SERVICE_DIR}/wordpress/assets/config/wp-config.php" ]; then

    log-helper debug "link ${CONTAINER_SERVICE_DIR}/wordpress/assets/config/wp-config.php to /var/www/wordpress/wp-config.php"
    ln -sf "${CONTAINER_SERVICE_DIR}/wordpress/assets/config/wp-config.php" /var/www/wordpress/wp-config.php

fi

# container first start
if [ ! -e "$FIRST_START_DONE" ]; then

  # Add .htaccess
  [ -e "/var/www/wordpress/.htaccess" ] || cp -f "${CONTAINER_SERVICE_DIR}/wordpress/assets/apache2/.htaccess" /var/www/wordpress/.htaccess

  # set new install default theme
  if [ -n "$WORDPRESS_DEFAULT_THEME" ]; then
    sed -i "s/define( 'WP_DEFAULT_THEME', '[^']*'/define( 'WP_DEFAULT_THEME', '${WORDPRESS_DEFAULT_THEME}'/g" /var/www/wordpress/wp-includes/default-constants.php
  fi

  cp -f "${CONTAINER_SERVICE_DIR}/wordpress/assets/php7.3-fpm/opcache.ini" /etc/php/7.3/fpm/conf.d/opcache.ini

  if [ "${WORDPRESS_PRODUCTION}" = "true" ]; then
    sed -i "s/;opcache.validate_timestamps/opcache.validate_timestamps/g" /etc/php/7.3/fpm/conf.d/opcache.ini
  fi

  touch "${FIRST_START_DONE}"
fi

# Fix file permission
find /var/www/ -type d -exec chmod 755 {} \;
find /var/www/ -type f -exec chmod 644 {} \;
chown www-data:www-data -R /var/www

# symlinks special (chown -R don't follow symlinks)
if [ -e "/var/www/wordpress/wp-config.php" ]; then

  chown www-data:www-data /var/www/wordpress/wp-config.php
  chmod 400 /var/www/wordpress/wp-config.php

fi
