#!/bin/bash

set -euo pipefail

NGINX_ROOT=${NGINX_ROOT:=/usr/share/nginx/html}
PHP_FPM_POOL_CONF=${PHP_FPM_POOL_CONF:-}

# Display PHP error's or not
if [[ "$ERRORS" == "1" ]] ; then
  sed -i -e "s/error_reporting =.*=/error_reporting = E_ALL/g" /etc/php/${IMAGE_PHP_VERSION}/fpm/php.ini
  sed -i -e "s/display_errors =.*/display_errors = On/g" /etc/php/${IMAGE_PHP_VERSION}/fpm/php.ini
else
  sed -i -e "s/error_reporting =.*=/error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT/g" /etc/php/${IMAGE_PHP_VERSION}/fpm/php.ini
  sed -i -e "s/display_errors =.*/display_errors = Off/g" /etc/php/${IMAGE_PHP_VERSION}/fpm/php.ini
fi

if [[ ! -z "$PHP_FPM_POOL_CONF" ]]; then
    echo "$PHP_FPM_POOL_CONF" > /etc/php/${IMAGE_PHP_VERSION}/fpm/pool.d/z-www.conf
fi

# Set the root in the conf
sed -i -e "s#%%NGINX_ROOT%%#$NGINX_ROOT#" /etc/nginx/sites-available/default.conf
sed -i -e "s#%%IMAGE_PHP_VERSION%%#$IMAGE_PHP_VERSION#" /etc/nginx/sites-available/default.conf

# Again set the right permissions (needed when mounting from a volume)
set +e 
chown -Rf www-data.www-data $NGINX_ROOT
set -e

# Start supervisord and services
exec /usr/bin/supervisord -n -c /etc/supervisord.conf
