FROM php:7.1-fpm

MAINTAINER Celerative <bruno.cascio@celerative>

# Deps
RUN apt-get update -y && apt-get install -y \
	nginx \
  curl \
  git \
	supervisor \
	# clean apt
	&& apt-get autoremove -y \
	&& apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
	# redirect nginx output to stdio
	&& ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log

# supervisor config
COPY ./configs/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
# nginx config
COPY ./configs/nginx.conf /etc/nginx/nginx.conf
# vhost config
COPY ./configs/vhost.conf /etc/nginx/sites-enabled/default
# fpm config
COPY ./configs/fpm.conf /etc/php-fpm.conf

CMD ["/usr/bin/supervisord"]

EXPOSE 80 443