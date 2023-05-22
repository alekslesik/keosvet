FROM php:7.4-apache

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions gd xdebug opcache pdo pdo_mysql mysqli

ADD ./httpd.conf /usr/local/apache2/conf/
ADD ./php.ini /usr/local/etc/php/conf.d/php.ini

WORKDIR /var/www/html

ADD ./bitrix_server_test.php .
ADD ./bitrixsetup.php .
ADD ./restore.php .


