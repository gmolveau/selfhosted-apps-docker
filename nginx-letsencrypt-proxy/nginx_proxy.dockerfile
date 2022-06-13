FROM nginxproxy/nginx-proxy:alpine

RUN printf "client_max_body_size 10G;\nproxy_request_buffering off;\nproxy_read_timeout 1000;" > /etc/nginx/conf.d/uploadsize.conf
RUN printf "proxy_buffer_size 16k;\nproxy_busy_buffers_size 24k;\nproxy_buffers 64 4k;" > /etc/nginx/conf.d/customproxy.conf
