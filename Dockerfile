FROM composer:1.9.3 as step1
COPY . /app/web
WORKDIR /app/web
ARG APP_ENV=prod
RUN if [ "$APP_ENV" = "prod" ] ; then composer update --no-dev --optimize-autoloader ; fi

FROM php:7.4-fpm
COPY --from=step1 /app /app
RUN apt-get update \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install pdo_mysql \
    && rm -rf /var/cache/apt/*

RUN chown -R www-data:www-data /app

EXPOSE 9000

WORKDIR /app/web

USER www-data
