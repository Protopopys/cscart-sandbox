ARG PHP_VERSION=5.3.29
FROM protopopys/docker-php:${PHP_VERSION}-fpm-alpine3.7
LABEL maintainer="Protopopys <protopopys@gmail.com>"
ENV PHPIZE_DEPS \
    coreutils \
	autoconf \
	dpkg-dev dpkg \
	file \
	g++ \
	gcc \
	libc-dev \
	make \
	pkgconf \
	re2c
RUN set -xe; \
    apk add --no-cache --update --virtual .build-deps \
	${PHPIZE_DEPS} \
#curl
    curl-dev \
#xml
	libxml2-dev \
#icu for intl
    icu-dev \
#imagick
    imagemagick6-dev \
#phar
    libressl-dev; \
    NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1); \
    docker-php-ext-install -j${NPROC} \
    exif \
    phar \
    json \
    intl \
    xml \
    curl \
    mysqli \
    mbstring \
    zip \
    soap \
 && pecl channel-update pecl.php.net \
 && pecl install imagick \
 && pecl install apcu=4.0.11 \
 && docker-php-ext-enable imagick apcu \
 && echo -e 'file_uploads = On\n\
memory_limit = 256M\n\
upload_max_filesize = 250M\n\
post_max_size = 250M\n\
max_execution_time = 600'\
>> /usr/local/etc/php/conf.d/docker-php-uploads.ini \
 && runDeps="$( \
		scanelf --needed --nobanner --format '%n#p' --recursive /usr/local \
			| tr ',' '\n' \
			| sort -u \
			| awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
	)" \
 && apk add --no-cache --virtual .php-rundeps $runDeps \
 && apk del .build-deps \
 && rm -rf /tmp/* /var/cache/apk/*  ~/.pearrc