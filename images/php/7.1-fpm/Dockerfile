FROM php:7.1-fpm

LABEL maintainer="Matias Anoniz <matiasanoniz@gmail.com>"

ENV PHP_EXTRA_CONFIGURE_ARGS --enable-fpm --with-fpm-user=www-data --with-fpm-group=www-data --enable-intl --enable-opcache --enable-zip

RUN apt-get update

#Install crontab
RUN apt-get install -y cron

RUN update-rc.d cron defaults

RUN \
  apt-get install -y \
  htop \
  mc \
  nano \
  libcurl4-gnutls-dev \
  libxml2-dev \
  libssl-dev

RUN \
    /usr/local/bin/docker-php-ext-install \
    dom \
    pcntl \
    phar \
    posix

# Configure PHP
# php module build deps
RUN \
  apt-get install -y \
  g++ \
  autoconf \
  libbz2-dev \
  libltdl-dev \
  libjpeg62-turbo-dev \
  libfreetype6-dev \
  libxpm-dev \
  libimlib2-dev \
  libicu-dev \
  libmcrypt-dev \
  libxslt1-dev \
  re2c \
  libpng++-dev \
  libvpx-dev \
  zlib1g-dev \
  libgd-dev \
  libtidy-dev \
  libmagic-dev \
  libexif-dev \
  file \
  libssh2-1-dev \
  libjpeg-dev \
  gnupg \
  git \
  curl \
  vim \
  wget \
  librabbitmq-dev \
  libzip-dev

# https://devdocs.magento.com/guides/v2.3/install-gde/system-requirements-tech.html
RUN \
    /usr/local/bin/docker-php-ext-install \
    pdo \
    sockets \
    pdo_mysql \
    mysqli \
    mbstring \
    mcrypt \
    hash \
    simplexml \
    xsl \
    soap \
    intl \
    bcmath \
    json \
    opcache \
    zip

# Install Node, NVM, NPM and Grunt

RUN curl -sL https://deb.nodesource.com/setup_11.x | bash - \
    && apt-get install -y nodejs build-essential \
    && curl https://raw.githubusercontent.com/creationix/nvm/v0.16.1/install.sh | sh \
    && npm i -g grunt-cli yarn

# Install fontforge https://github.com/sapegin/grunt-webfont#installation
RUN apt-get install -y fontforge ttfautohint

# Make sure the volume mount point is empty
RUN rm -rf /var/www/html/*

# Create .ssh file
RUN mkdir -p /var/www/.ssh

# Set www-data as owner for /var/www
RUN chown -R www-data:www-data /var/www/
RUN chmod -R g+w /var/www/

# Create log folders
RUN rm -rf /var/log/php-fpm # Delete if exist
RUN mkdir -p /var/log/php-fpm && \
    touch /var/log/php-fpm/access.log && \
    touch /var/log/php-fpm/fpm-error.log && \
    touch /var/log/php-fpm/fpm-php.www.log && \
    chown -R www-data:www-data /var/log/php-fpm

RUN wget https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz && \
  tar -zxf ioncube_loaders_lin_x86-64.tar.gz && \
  mv ioncube/ioncube_loader_lin_7.1.so /usr/local/lib/php/extensions/no-debug-non-zts-20160303/iocube.so && \
  echo "zend_extension = /usr/local/lib/php/extensions/no-debug-non-zts-20160303/iocube.so" > /usr/local/etc/php/conf.d/10-php-ext-ioncube.ini

RUN docker-php-ext-configure gd --with-freetype-dir=/usr --with-jpeg-dir=/usr --with-png-dir=/usr \
    && docker-php-ext-install gd

RUN curl -sS https://getcomposer.org/installer | \
  php -- --install-dir=/usr/local/bin --filename=composer

RUN pecl install -o -f xdebug

RUN chmod a+x /usr/local/lib/php/extensions/no-debug-non-zts-20160303/xdebug.so 

# ENV PHP_MEMORY_LIMIT 2G
# ENV PHP_PORT 9000
# ENV PHP_PM dynamic
# ENV PHP_PM_MAX_CHILDREN 10
# ENV PHP_PM_START_SERVERS 4
# ENV PHP_PM_MIN_SPARE_SERVERS 2
# ENV PHP_PM_MAX_SPARE_SERVERS 6
# ENV APP_MAGE_MODE default