#!/bin/bash -e
# this script is run during the container start

FIRST_START_DONE="/etc/docker-wordpress-first-start-done"

# container first start
if [ ! -e "$FIRST_START_DONE" ]; then
  
  # create wordpress vhost
  if [ "$HTTPS" == "true" ]; then

    # check certificat and key or create them
    /sbin/ssl-kit "/osixia/wordpress/apache2/$SSL_CRT_FILENAME" "/osixia/wordpress/apache2/$SSL_KEY_FILENAME"

    # add CA certificat config if CA cert exists
    if [ -e "/osixia/wordpress/apache2/$SSL_CA_CRT_FILENAME" ]; then
      sed -i "s/#SSLCACertificateFile/SSLCACertificateFile/g" /osixia/wordpress/apache2/wordpress-ssl.conf
    fi

    a2ensite wordpress-ssl

  else
    a2ensite wordpress
  fi

  # set new install default theme
  if [ -n "$WORDPRESS_DEFAULT_THEME" ]; then
    sed -i "s/define( 'WP_DEFAULT_THEME', '[^']*'/define( 'WP_DEFAULT_THEME', '${WORDPRESS_DEFAULT_THEME}'/g" /var/www/wordpress/wp-includes/default-constants.php
  fi

  # set db configuration
  sed -i "s/define('DB_NAME', '[^']*'/define('DB_NAME', '${DB_NAME}'/g" /var/www/wp-config.php
  sed -i "s/define('DB_USER', '[^']*'/define('DB_USER', '${DB_USER}'/g" /var/www/wp-config.php
  sed -i "s/define('DB_PASSWORD', '[^']*'/define('DB_PASSWORD', '${DB_PASSWORD}'/g" /var/www/wp-config.php
  sed -i "s/define('DB_HOST', '[^']*'/define('DB_HOST', '${DB_HOST}'/g" /var/www/wp-config.php
  sed -i "s/$table_prefix  = '[^']*'/$table_prefix  = '${DB_TABLE_PREFIX}'/g" /var/www/wp-config.php

  # set authentication unique keys and salts.
  get_salt () {
    salt=$(</dev/urandom tr -dc '1324567890#<>,()*.^@$% =-_~;:|{}[]+!`azertyuiopqsdfghjklmwxcvbnAZERTYUIOPQSDFGHJKLMWXCVBN' | head -c64 | tr -d '\\')
  }

  toSalt=( AUTH_KEY SECURE_AUTH_KEY LOGGED_IN_KEY NONCE_KEY AUTH_SALT SECURE_AUTH_SALT LOGGED_IN_SALT NONCE_SALT )
  for key in ${toSalt[*]}
  do
    get_salt
    sed -i "s/define('${key}', *'[^']*'/define('${key}', '${salt}'/g" /var/www/wp-config.php 
  done

  touch $FIRST_START_DONE
fi

exit 0