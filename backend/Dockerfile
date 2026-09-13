FROM php:8.2-fpm

# Install dependencies sistem & ekstensi PHP yang dibutuhkan Laravel
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl \
    libonig-dev \
    libxml2-dev \
    libzip-dev

RUN docker-php-ext-install pdo_mysql mbstring zip exif pcntl bcmath gd
RUN pecl install redis && docker-php-ext-enable redis

# Allow more concurrent PHP requests while keeping the process pool bounded.
RUN sed -i \
    -e 's/^;\?pm.max_children = .*/pm.max_children = 20/' \
    -e 's/^;\?pm.start_servers = .*/pm.start_servers = 4/' \
    -e 's/^;\?pm.min_spare_servers = .*/pm.min_spare_servers = 2/' \
    -e 's/^;\?pm.max_spare_servers = .*/pm.max_spare_servers = 8/' \
    /usr/local/etc/php-fpm.d/www.conf

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

# Copy kode Laravel
COPY . /var/www

# Install dependensi Laravel & atur permission
RUN composer install --no-interaction --prefer-dist --optimize-autoloader
RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache

EXPOSE 9000
CMD ["php-fpm"]