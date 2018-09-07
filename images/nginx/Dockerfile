FROM nginx:stable-alpine
COPY --chown=root:root html /etc/nginx/html  
COPY --chown=root:root templates /etc/nginx/templates
COPY --chown=root:root nginx.conf /etc/nginx/
