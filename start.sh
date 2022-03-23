#!/bin/sh
/usr/local/php/sbin/php-fpm -c /usr/local/php/etc/php-fpm.conf -D
/usr/local/nginx/sbin/nginx -c /usr/local/nginx/conf/nginx.conf
tail -f /dev/null
