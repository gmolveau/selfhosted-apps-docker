FROM nginxproxy/nginx-proxy:1.6.4-alpine

COPY proxy.conf /etc/nginx/proxy.conf
COPY uploadsize.conf /etc/nginx/conf.d/uploadsize.conf
