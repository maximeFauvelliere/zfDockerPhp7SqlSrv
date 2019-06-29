# FROM php:5.6-apache

# WORKDIR /var/www

# RUN apt-get update \
#  && apt-get install -y git zlib1g-dev \
#  && docker-php-ext-install zip \
#  && docker-php-ext-install pdo pdo_mysql \
#  && docker-php-ext-install mysqli \
#  && a2enmod rewrite \
#  && sed -i 's!/var/www/html!/var/www/public!g' /etc/apache2/sites-available/000-default.conf \
#  && sed -i 's!/var/www/html!/var/www/public!g' /etc/apache2/sites-available/default-ssl.conf \
#  && mv /var/www/html /var/www/public \
#  && openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/ssl-cert-snakeoil.key -out /etc/ssl/certs/ssl-cert-snakeoil.pem -subj "/C=AT/ST=Vienna/L=Vienna/O=Security/OU=Development/CN=example.com" \
#  && a2ensite default-ssl \
#  && a2enmod ssl

FROM php:7.1.20-apache

RUN apt-get -y update --fix-missing
RUN apt-get upgrade -y

# Install useful tools
RUN apt-get -y install apt-utils nano wget dialog

# Install important libraries
RUN apt-get -y install --fix-missing apt-utils build-essential git curl libcurl3 libcurl3-dev zip

# Install xdebug
RUN pecl install xdebug-2.5.0
RUN docker-php-ext-enable xdebug
RUN apt-get update
# RUN apt-get install gnupg
RUN apt-get update && apt-get dist-upgrade -y && apt-get install -y gnupg
RUN apt-get install apt-transport-https
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/debian/9/prod.list > /etc/apt/sources.list.d/mssql-release.list
RUN apt-get update 
# RUN ACCEPT_EULA=Y apt-get install msodbcsql17 //crash
RUN ACCEPT_EULA=Y apt-get install -y msodbcsql17 && ACCEPT_EULA=Y apt-get install mssql-tools
# RUN "export PATH='$PATH:/opt/mssql-tools/bin'" >> ~/.bash_profile
# RUN "export PATH='$PATH:/opt/mssql-tools/bin'" >> ~/.bashrc
# RUN source ~/.bashrc
# optional: for unixODBC development headers
RUN apt-get -y install unixodbc-dev
RUN apt-get update
# RUN sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen //crash mais surement nécessaire
# RUN locale-gen //crash mais surement nécessaire
RUN pecl install sqlsrv
RUN pecl install pdo_sqlsrv

RUN echo extension=pdo_sqlsrv.so >> `php --ini | grep "Scan for additional .ini files" | sed -e "s|.*:\s*||"`/30-pdo_sqlsrv.ini
RUN echo extension=sqlsrv.so >> `php --ini | grep "Scan for additional .ini files" | sed -e "s|.*:\s*||"`/20-sqlsrv.ini
RUN apt-get update
RUN apt search php7
# RUN apt-get install libapache2-mod-php7.1 apache2
RUN a2dismod mpm_event
RUN a2enmod mpm_prefork
RUN a2enmod php7
# RUN apt search php.ini
# RUN echo "extension=pdo_sqlsrv.so" >> /etc/php/7/apache2/conf.d/30-pdo_sqlsrv.ini
# RUN echo "extension=sqlsrv.so" >> /etc/php/7/apache2/conf.d/20-sqlsrv.ini



