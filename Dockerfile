# FROM johnpbloch/phpfpm:7.1

FROM php:7.1-fpm

# Configure postfix mail server
# RUN apt-get install -y --no-install-recommends debconf && export DEBIAN_FRONTEND=noninteractive 
#    && debconf-set-selections <<< "postfix postfix/mailname $(-e myhostname)"" \
#    && debconf-set-selections <<< "postfix postfix/main_mailer_type $(-e main_mailer_type)

# install essnsial server stuff
RUN DEBIAN_FRONTEND=noninteractive apt-get update \
    && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libz-dev \
        less \
        # postfix \
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
    


# Install OS utilities
RUN apt-get update
RUN apt-get -y install \
    curl 

# Add Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# ensure www-data user exists
RUN usermod -u 1000 www-data
RUN usermod -G www-data www-data

# Cleanup
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add WP-CLI, https://github.com/conetix/docker-wordpress-wp-cli example
RUN curl -o /bin/wp-cli.phar https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
COPY wp-su.sh /bin/wp
RUN chmod +x /bin/wp-cli.phar /bin/wp

CMD ["php-fpm"]

EXPOSE 9000