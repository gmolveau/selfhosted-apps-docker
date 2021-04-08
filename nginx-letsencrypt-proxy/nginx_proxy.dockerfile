FROM jwilder/nginx-proxy:alpine

RUN echo -e "client_max_body_size 10G;\nproxy_request_buffering off;" > /etc/nginx/conf.d/uploadsize.conf
