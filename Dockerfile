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
RUN apt-get update && apt-get dist-upgrade -y && apt-get install -y gnupg
RUN apt-get install apt-transport-https
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/debian/9/prod.list > /etc/apt/sources.list.d/mssql-release.list
RUN apt-get update 
RUN ACCEPT_EULA=Y apt-get install -y msodbcsql17 && ACCEPT_EULA=Y apt-get install mssql-tools

RUN apt-get -y install unixodbc-dev
RUN apt-get update
RUN pecl install sqlsrv
RUN pecl install pdo_sqlsrv

RUN echo extension=pdo_sqlsrv.so >> `php --ini | grep "Scan for additional .ini files" | sed -e "s|.*:\s*||"`/30-pdo_sqlsrv.ini
RUN echo extension=sqlsrv.so >> `php --ini | grep "Scan for additional .ini files" | sed -e "s|.*:\s*||"`/20-sqlsrv.ini
RUN apt-get update 
RUN a2dismod mpm_event
RUN a2enmod mpm_prefork
RUN a2enmod php7




