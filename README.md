# docker-nginx-php7-fpm
Dockerfile for nginx and php-fpm together.

Composer is also installed for convenience.

Doc root is in `/usr/share/nginx/html` so mounting files there will get them served. 
This can be overridden by setting the env NGINX_ROOT in the container or when building an image from this one.

An `ERRORS` env can be set to toggle error reporting. Check out `cmd.sh` to see what happens. 
`ERRORS=1` will trigger error reporting, everything else keeps it turned off.
