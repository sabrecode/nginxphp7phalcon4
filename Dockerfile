FROM webdevops/php-nginx:7.4-alpine

LABEL maintainer="codesaber@gmail.com"

RUN apk update && apk add --no-cache \
        autoconf \
        build-base 

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
