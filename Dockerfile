FROM php:8.4-apache

RUN apt-get update && apt-get install -y \
    git unzip curl libicu-dev libgmp-dev libpng-dev libjpeg-dev libfreetype6-dev \
    libmaxminddb-dev pkg-config libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Instala extensões necessárias
RUN docker-php-ext-install intl gmp gd \
    && pecl install redis \
    && pecl install maxminddb \
    && docker-php-ext-enable redis maxminddb ffi


# Clona o AzuraCast
RUN git clone --branch stable https://github.com/AzuraCast/AzuraCast.git /var/azuracast

WORKDIR /var/azuracast

# Instala Composer e dependências
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer install --no-dev --no-interaction --optimize-autoloader

WORKDIR /var/azuracast/www

ENV AZURACAST_DB_TYPE=pgsql \
    DISABLE_MARIADB=true \
    DISABLE_REDIS=true

EXPOSE 80

CMD ["php", "-S", "0.0.0.0:80", "-t", "public"]

CMD ["php", "-S", "0.0.0.0:80", "-t", "public"]
