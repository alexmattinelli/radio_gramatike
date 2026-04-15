FROM php:8.4-apache

RUN apt-get update && apt-get install -y --no-install-recommends \
    git unzip curl libicu-dev libgmp-dev libpng-dev libjpeg-dev libfreetype6-dev \
    libmaxminddb-dev pkg-config libssl-dev libffi-dev zlib1g-dev libzip-dev \
    && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install intl gmp gd ffi \
    && pecl install redis \
    && pecl install maxminddb \
    && docker-php-ext-enable redis maxminddb ffi

RUN git clone --branch stable https://github.com/AzuraCast/AzuraCast.git /var/azuracast

WORKDIR /var/azuracast

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer install --no-dev --no-interaction --optimize-autoloader

# Copia os arquivos da pasta correta (web)
RUN cp -r /var/azuracast/web/* /var/www/html/

ENV AZURACAST_DB_TYPE=pgsql \
    DISABLE_MARIADB=true \
    DISABLE_REDIS=true

EXPOSE 80

CMD ["apache2-foreground"]
