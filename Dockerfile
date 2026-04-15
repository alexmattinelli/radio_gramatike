FROM php:8.2-apache

RUN apt-get update && apt-get install -y \
    git unzip curl \
    && rm -rf /var/lib/apt/lists/*

RUN git clone --branch stable https://github.com/AzuraCast/AzuraCast.git /var/azuracast

WORKDIR /var/azuracast

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer install --no-dev --no-interaction --optimize-autoloader

WORKDIR /var/azuracast/www

ENV AZURACAST_DB_TYPE=pgsql \
    DISABLE_MARIADB=true \
    DISABLE_REDIS=true

EXPOSE 80

CMD ["php", "-S", "0.0.0.0:80", "-t", "public"]

CMD ["php", "-S", "0.0.0.0:80", "-t", "public"]

