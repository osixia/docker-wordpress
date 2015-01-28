#!/bin/bash
# this script is run during the image build

# remove apache default host
a2dissite 000-default

# add mod_rewrite apache module
a2enmod rewrite

# Move wp-config.php 
mv /var/www/wordpress/wp-config-sample.php /var/www/wp-config.php

# Disable file edit
echo "define('DISALLOW_FILE_EDIT',true);" >> /var/www/wp-config.php 

# Disable auto update
echo "add_filter('automatic_updater_disabled', '__return_true');" >> /var/www/wp-config.php

# Replace login errors with a less precise text
echo "add_filter('login_errors', create_function('$no_login_error', \"return 'Bad credentials';\"));" >> /var/www/wp-config.php

# fix file permission
find /var/www/ -type d -exec chmod 755 {} \;
find /var/www/ -type f -exec chmod 644 {} \;