FROM nginxproxy/nginx-proxy:1.7.0-alpine

COPY proxy.conf /etc/nginx/proxy.conf
COPY uploadsize.conf /etc/nginx/conf.d/uploadsize.conf
