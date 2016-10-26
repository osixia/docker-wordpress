#!/bin/bash -e
# this script is run during the image build

# set -x (bash debug) if log level is trace
# https://github.com/osixia/docker-light-baseimage/blob/stable/image/tool/log-helper
log-helper level eq trace && set -x

# Remove apache default host
a2dissite 000-default
rm -rf /var/www/html

# Add mod_rewrite apache module
a2enmod rewrite
