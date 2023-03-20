FROM php:8.1-apache
WORKDIR /app
COPY . /app
COPY Docker/apache2.conf /etc/apache2/apache2.conf
#COPY Docker/default /app/default.conf
RUN set -eux; \
    \
    if command -v a2enmod; then \
        a2enmod rewrite; \
    fi; \
    \
    savedAptMark="$(apt-mark showmanual)"; \
    \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        libfreetype6-dev \
        libjpeg-dev \
        libpng-dev \
        libpq-dev \
        libicu-dev \
        vim \
        wget \
        mariadb-client \
        libzip-dev \
        cron \
        git \
        openssh-server \
    ; \
     \
    docker-php-ext-configure gd \
        --with-freetype \
        --with-jpeg=/usr \
    ; \
    \
    docker-php-ext-install -j "$(nproc)" \
        gd \
        opcache \
        pdo_mysql \
        pdo_pgsql \
        zip \
        mysqli
RUN apt-get -y update 
RUN apt-get install -y libicu-dev 
RUN docker-php-ext-configure intl 
RUN docker-php-ext-install intl 

#RUN sed -ii "s/^[ \t]*DocumentRoot \/var\/www\/html$/DocumentRoot \/app\/web/" /etc/apache2/sites-available/000-default.conf;
COPY Docker/uploads.ini /usr/local/etc/php/conf.d
COPY Docker/default /etc/apache2/sites-enabled/000-default.conf
#RUN chown -R www-data. /app/web
EXPOSE 80 2222
