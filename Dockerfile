FROM php:7.1-fpm

# install essnsial server stuff
RUN apt-get update \
    && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libz-dev \
    less \
    mariadb-client \
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
    curl \
    nano

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

# Aws cli tools
RUN apt-get update && \
    apt-get install -y \
    groff \
    less \
    python3 \
    python3-pip \
    python3-setuptools \
    && pip3 install --upgrade pip \
    && apt-get clean

RUN pip3 --no-cache-dir install --upgrade awscli

# install docker
RUN apt-get update && \
    apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common \
    && curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - \
    && add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/debian \
    $(lsb_release -cs) \
    stable"

RUN apt-get update && \
    apt-get install -y docker-ce

COPY dockerd-entrypoint.sh /usr/local/bin/

EXPOSE 9000