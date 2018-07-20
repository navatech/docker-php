FROM php:7.1.19
RUN apt-get update -y && \
    apt-get install -yqq git libmcrypt-dev libpq-dev libcurl4-gnutls-dev libicu-dev libvpx-dev libjpeg-dev libpng-dev libxpm-dev zlib1g-dev libfreetype6-dev libxml2-dev libexpat1-dev libbz2-dev libgmp3-dev libldap2-dev unixodbc-dev libsqlite3-dev libaspell-dev libsnmp-dev libpcre3-dev libtidy-dev && \
    docker-php-ext-install mbstring mcrypt pdo_pgsql curl json intl gd xml zip bz2 opcache
RUN pecl install xdebug && docker-php-ext-enable xdebug
RUN wget https://composer.github.io/installer.sig -O - -q | tr -d '\n' > installer.sig && \
	php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
	php -r "if (hash_file('SHA384', 'composer-setup.php') === file_get_contents('installer.sig')) { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
	php composer-setup.php --filename=composer --install-dir=/usr/local/bin && \
	php -r "unlink('composer-setup.php'); unlink('installer.sig');" && \
	composer global require hirak/prestissimo
EXPOSE 80
CMD ["apache2-foreground"]