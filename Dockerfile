FROM php:8.3-apache

ARG USER_ID=1000
ARG GROUP_ID=1000

RUN --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
    --mount=target=/var/cache/apt,type=cache,sharing=locked \
    rm -f /etc/apt/apt.conf.d/docker-clean \
    && apt-get update -y && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libonig-dev \
    libzip-dev \
    libpng-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install \
    mbstring \
    pdo_mysql \
    zip \
    gd \
    && pecl install xdebug && docker-php-ext-enable xdebug

RUN --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
    --mount=target=/var/cache/apt,type=cache,sharing=locked \
    rm -f /etc/apt/apt.conf.d/docker-clean \
    && apt-get install -y curl \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs

RUN mkdir "/.npm" && chown -R $USER_ID:$GROUP_ID "/.npm"

RUN mkdir -p "/opt/phpstorm-coverage" && \
    chmod a+rw "/opt/phpstorm-coverage"

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer