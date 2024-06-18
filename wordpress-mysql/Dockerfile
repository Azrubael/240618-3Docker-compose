FROM wordpress:latest

COPY wp-config.php /var/www/html/wp-config.php

RUN getent group www-data || groupadd -g 1961 www-data
RUN id -u www-data &>/dev/null || useradd -r -u 1492 -g www-data www-data
RUN chown www-data:www-data /var/www/html/wp-config.php

RUN apt-get update && apt-get install -y iputils-ping
