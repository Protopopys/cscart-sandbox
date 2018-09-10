FROM nginx:stable-alpine
RUN set -x \
	&& addgroup -g 82 -S www-data \
	&& adduser -u 82 -D -S -G www-data www-data
COPY --chown=root:root html /etc/nginx/html  
COPY --chown=root:root templates /etc/nginx/templates
COPY --chown=root:root nginx.conf /etc/nginx/
