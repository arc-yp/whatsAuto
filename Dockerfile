# Production Dockerfile for Laravel on Railway
# Uses Apache with PHP 8.2 and required extensions

FROM php:8.2-apache

# Set working directory
WORKDIR /var/www/html

# Install system dependencies and PHP extensions
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        git \
        unzip \
        libzip-dev \
        libpng-dev \
        libonig-dev \
        libicu-dev \
        libxml2-dev \
    && docker-php-ext-configure zip \
    && docker-php-ext-install \
        pdo \
        pdo_mysql \
        bcmath \
        zip \
    && rm -rf /var/lib/apt/lists/*

# Enable Apache modules and set DocumentRoot to public/
RUN a2enmod rewrite \
    && sed -ri 's!/var/www/html!/var/www/html/public!g' /etc/apache2/sites-available/000-default.conf \
    && sed -ri 's!/var/www/!/var/www/html/public!g' /etc/apache2/apache2.conf

# Copy composer from official image
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Copy application files
COPY . /var/www/html

# Ensure correct permissions for storage and bootstrap/cache
RUN chown -R www-data:www-data /var/www/html \
    && find storage bootstrap/cache -type d -exec chmod 775 {} \; \
    && find storage bootstrap/cache -type f -exec chmod 664 {} \;

# Environment for Composer
ENV COMPOSER_ALLOW_SUPERUSER=1 \
    COMPOSER_PROCESS_TIMEOUT=600

# Optionally pass a GitHub token at build time to avoid API rate limits
ARG GITHUB_TOKEN
RUN if [ -n "$GITHUB_TOKEN" ]; then \
      composer config -g --auth github-oauth.github.com "$GITHUB_TOKEN"; \
    fi

# Install PHP dependencies (no scripts to avoid artisan calls during build)
RUN composer install \
    --no-dev \
    --prefer-dist \
    --optimize-autoloader \
    --no-interaction \
    --no-scripts

# Expose Apache port
EXPOSE 80

# Default command (Apache in foreground)
CMD ["apache2-foreground"]
