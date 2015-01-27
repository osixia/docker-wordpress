#!/bin/bash
# this script is run during the container start

FIRST_START_DONE="/etc/docker-wordpress-first-start-done"

# container first start
if [ ! -e "$FIRST_START_DONE" ]; then
  
  # create wordpress vhost
  if [ "$HTTPS" == "true" ]; then
    /sbin/nginx-add-vhost wordpress /var/www/wordpress localhost $HOSTNAME --php --ssl \
                          --ssl-crt=/etc/nginx/wordpress/ssl/$SSL_CRT_FILENAME \
                          --ssl-key=/etc/nginx/wordpress/ssl/$SSL_KEY_FILENAME
  else
    /sbin/nginx-add-vhost wordpress /var/www/wordpress localhost $HOSTNAME --php
  fi

  # remove default vhost
  /sbin/nginx-remove-vhost default

  # add nginx config
  cat /etc/nginx/wordpress/nginx.conf >> /etc/nginx/nginx.conf
  ln -s /etc/nginx/wordpress/http.conf /etc/nginx/conf.d/wordpress.conf
  /sbin/nginx-vhost-add-config wordpress "$(cat /etc/nginx/wordpress/server.conf)"

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