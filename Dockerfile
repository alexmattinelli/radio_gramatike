FROM php:8.4-apache

RUN apt-get update && apt-get install -y --no-install-recommends \
    git unzip curl libicu-dev libgmp-dev libpng-dev libjpeg-dev libfreetype6-dev \
    libmaxminddb-dev pkg-config libssl-dev libffi-dev zlib1g-dev libzip-dev \
    && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install intl gmp gd ffi \
    && pecl install redis \
    && pecl install maxminddb \
    && docker-php-ext-enable redis maxminddb ffi

# Clona o AzuraCast
RUN git clone --branch stable https://github.com/AzuraCast/AzuraCast.git /var/azuracast

WORKDIR /var/azuracast

# Instala Composer e dependências
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer install --no-dev --no-interaction --optimize-autoloader

# Configura Apache para servir AzuraCast
RUN a2enmod rewrite \
    && echo '<VirtualHost *:80>\n\
    DocumentRoot /var/azuracast/web\n\
    <Directory /var/azuracast/web>\n\
        Options Indexes FollowSymLinks\n\
        AllowOverride All\n\
        Require all granted\n\
    </Directory>\n\
</VirtualHost>' > /etc/apache2/sites-available/000-default.conf

# Corrige diretórios temporários e persistentes
RUN mkdir -p /var/www_tmp /var/azuracast/tmp /var/azuracast/data /var/azuracast/stations \
    && chown -R www-data:www-data /var/www_tmp /var/azuracast/tmp /var/azuracast/data /var/azuracast/stations \
    && chmod -R 775 /var/www_tmp /var/azuracast/tmp /var/azuracast/data /var/azuracast/stations

WORKDIR /var/azuracast/web

ENV AZURACAST_DB_TYPE=pgsql \
    DISABLE_MARIADB=true \
    DISABLE_REDIS=true \
    AZURACAST_TEMP_DIR=/var/azuracast/tmp

EXPOSE 80

CMD ["apache2-foreground"]
