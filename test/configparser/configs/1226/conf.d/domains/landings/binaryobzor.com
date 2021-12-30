server {
    listen 206.54.170.43:80;
    listen 206.54.170.56:80;
    server_name www.binaryobzor.com;
    status_zone "landings:www.binaryobzor.com";
    access_log /var/log/nginx/binaryobzor.com_http_access.log main buffer=1m;
    include /etc/nginx/conf.d/google_takeme;
    include /etc/nginx/conf.d/upstreams_log;
#    include /etc/nginx/conf.d/static;
    include /etc/nginx/conf.d/favicon;
    include /etc/nginx/conf.d/rewrite_binaryobzor.com;
}

server {
    listen 206.54.170.43:80;
    listen 206.54.170.56:80;
    server_name binaryobzor.com;
    status_zone "landings:binaryobzor.com";
    access_log /var/log/nginx/binaryobzor.com_http_access.log main buffer=1m;
    include /etc/nginx/conf.d/google_takeme;
    include /etc/nginx/conf.d/upstreams_log;
#    include /etc/nginx/conf.d/static;
    include /etc/nginx/conf.d/favicon;
    include /etc/nginx/conf.d/locations_landings_http_include;
#    include /etc/nginx/conf.d/locations_promo_http_include;
}

