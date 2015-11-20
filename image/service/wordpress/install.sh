#!/bin/bash -e
# this script is run during the image build

# Add wordpress virtualhosts
ln -s /container/service/wordpress/assets/apache2/wordpress.conf /etc/apache2/sites-available/wordpress.conf
ln -s /container/service/wordpress/assets/apache2/wordpress-ssl.conf /etc/apache2/sites-available/wordpress-ssl.conf

# Remove apache default host
a2dissite 000-default
rm -rf /var/www/html

# Add mod_rewrite apache module
a2enmod rewrite

# Install plugins and themes
cp /container/service/wordpress/assets/wp-content/* /var/www/wordpress_bootstrap/wp-content

# Disable file edit
echo "define('DISALLOW_FILE_EDIT',true);" >> /var/www/wordpress_bootstrap/wp-config-sample.php

# Disable auto update
echo "add_filter('automatic_updater_disabled', '__return_true');" >> /var/www/wordpress_bootstrap/wp-config-sample.php

# Replace login errors with a less precise text
echo "add_filter('login_errors', create_function('$no_login_error', \"return 'Bad credentials';\"));" >> /var/www/wordpress_bootstrap/wp-config-sample.php

# Add .htaccess
cp /container/service/wordpress/assets/apache2/.htaccess /var/www/wordpress_bootstrap/.htaccess
