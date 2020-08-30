FROM webdevops/php-nginx:7.4-alpine

LABEL maintainer="codesaber@gmail.com"

# adding support for MS SQL
RUN apk update && apk add --no-cache \
        autoconf \
        build-base \
        && echo http://dl-cdn.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories \
        && apk update \
        && apk add freetds freetds-dev unixodbc unixodbc-dev \
        && pecl install sqlsrv \
        && pecl install pdo_sqlsrv \
        && echo extension=pdo_sqlsrv.so >> `php --ini | grep "Scan for additional .ini files" | sed -e "s|.*:\s*||"`/10_pdo_sqlsrv.ini \
        && echo extension=sqlsrv.so >> `php --ini | grep "Scan for additional .ini files" | sed -e "s|.*:\s*||"`/00_sqlsrv.ini

WORKDIR /usr/local/src
RUN git clone --depth=1 https://github.com/jbboehr/php-psr.git
WORKDIR /usr/local/src/php-psr
RUN phpize && ./configure && make && make test && make install
WORKDIR /
RUN rm -rf /usr/local/src/php-psr
#enable psr
RUN docker-php-ext-enable psr

#install phalcon
WORKDIR /usr/local/src
RUN git clone --depth=1 "git://github.com/phalcon/cphalcon.git"
WORKDIR /usr/local/src/cphalcon/build
RUN ./install
WORKDIR /
RUN rm -rf /usr/local/src/cphalcon \
    && docker-php-ext-enable phalcon 
