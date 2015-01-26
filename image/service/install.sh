#!/bin/bash
# this script is run during the image build

# Disable auto update
echo "add_filter('automatic_updater_disabled', '__return_true');" >> /var/www/wordpress/wp-includes/functions.php

# Replace login errors with a less precise text
echo "add_filter('login_errors', create_function('$no_login_error', \"return 'Bad credentials';\"));" >> /var/www/wordpress/wp-includes/functions.php

# Disable file edit
echo "define('DISALLOW_FILE_EDIT',true);" >> /var/www/wordpress/wp-config.php 

# Move wp-config.php 
mv /var/www/wordpress/wp-config.php /var/www/wp-config.php