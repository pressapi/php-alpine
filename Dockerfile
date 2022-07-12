FROM php:8.1.8-fpm-alpine

ENV COMPOSER_ALLOW_SUPERUSER=1 \
    COMPOSER_MEMORY_LIMIT=-1 \
    WORKDIR=/var/www/html

WORKDIR $WORKDIR

RUN apk update && \
    apk add --no-cache libzip-dev nginx supervisor bash && \
    docker-php-ext-install zip mysqli pdo pdo_mysql opcache && \
    docker-php-ext-configure zip && \
    sed -i "s/access.log/; access.log/" /usr/local/etc/php-fpm.d/docker.conf && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

COPY ./.docker /

ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
