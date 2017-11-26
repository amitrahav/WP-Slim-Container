# FROM johnpbloch/phpfpm:7.1

FROM php:7.1-fpm

# install essnsial server stuff
RUN apt-get update \
    && echo "postfix postfix/mailname string example.com" | debconf-set-selections \
    && echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections \
    && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng12-dev \
        libz-dev \
        less \
        postfix \
        mysql-client \
    && docker-php-ext-install -j$(nproc) \
        mysqli \
        pdo \
        pdo_mysql \
        sockets \
        zip \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && apt-get remove -y build-essential libz-dev \
    && apt-get autoremove -y \
    && apt-get clean


# php testing helpers
#RUN curl -L https://phar.phpunit.de/phpunit.phar > /tmp/phpunit.phar \
#    && chmod +x /tmp/phpunit.phar \
#    && mv /tmp/phpunit.phar /usr/local/bin/phpunit

# Install OS utilities
RUN apt-get update
RUN apt-get -y install \
    curl 

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

CMD ["php-fpm"]

EXPOSE 9000