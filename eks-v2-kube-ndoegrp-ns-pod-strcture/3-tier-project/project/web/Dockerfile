FROM nginx:alpine

COPY nginx.conf /etc/nginx/nginx.conf
COPY html /usr/share/nginx/html
COPY config /usr/share/nginx/config

CMD ["sh","-c","cp $CONFIG_JSON /usr/share/nginx/html/config.json && nginx -g 'daemon off;'"]