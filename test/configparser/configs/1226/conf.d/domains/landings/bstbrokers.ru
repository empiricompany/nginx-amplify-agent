server {
    listen 206.54.170.43:80;
    listen 206.54.170.56:80;
    server_name www.bstbrokers.ru;
    status_zone "landings:www.bstbrokers.ru";
    access_log /var/log/nginx/bstbrokers.ru_http_access.log main buffer=1m;
    include /etc/nginx/conf.d/google_takeme;
    include /etc/nginx/conf.d/upstreams_log;
#    include /etc/nginx/conf.d/static;
    include /etc/nginx/conf.d/favicon;
    include /etc/nginx/conf.d/rewrite_bstbrokers.ru;
}

server {
    listen 206.54.170.43:80;
    listen 206.54.170.56:80;
    server_name bstbrokers.ru;
    status_zone "landings:bstbrokers.ru";
    access_log /var/log/nginx/bstbrokers.ru_http_access.log main buffer=1m;
    include /etc/nginx/conf.d/google_takeme;
    include /etc/nginx/conf.d/upstreams_log;
#    include /etc/nginx/conf.d/static;
    include /etc/nginx/conf.d/favicon;
    include /etc/nginx/conf.d/rewrite_bstbrokers.ru;
}

server {
    listen 206.54.170.43:443 ssl;
    listen 206.54.170.56:443 ssl;
    server_name bstbrokers.ru;
    status_zone "landings:bstbrokers.ru";
    include /etc/nginx/conf.d/include_ssl;
    ssl_certificate /etc/nginx/ssl/landings/bstbrokers.ru.crt;
    ssl_certificate_key /etc/nginx/ssl/landings/bstbrokers.ru.key;
    access_log /var/log/nginx/bstbrokers.ru_https_access.log main buffer=1m;
    include /etc/nginx/conf.d/upstreams_log;
#    include /etc/nginx/conf.d/static;
    include /etc/nginx/conf.d/favicon;
    include /etc/nginx/conf.d/locations_landings_https_include;
}
