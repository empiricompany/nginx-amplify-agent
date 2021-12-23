server {
    listen 206.54.170.45:80;
    listen 206.54.170.58:80;
    server_name new.iqoption.com;
    status_zone "new:new.iqoption.com";
    access_log /var/log/nginx/new.iqoption.com_http_access.log main buffer=1m;
    include /etc/nginx/conf.d/google_takeme;
    include /etc/nginx/conf.d/upstreams_log;
    include /etc/nginx/conf.d/favicon;
    include /etc/nginx/conf.d/rewrite_new.iqoption.com;
}

server {
    listen 206.54.170.45:443 ssl;
    listen 206.54.170.58:443 ssl;
    server_name new.iqoption.com;
    status_zone "new:new.iqoption.com";
#    include /etc/nginx/conf.d/include_ssl;
#    ssl_certificate /etc/nginx/ssl/frontend/new.iqoption.com.crt;
#    ssl_certificate_key /etc/nginx/ssl/frontend/new.iqoption.com.key;
    include /etc/nginx/conf.d/include_ssl_sha2;
    ssl_certificate /etc/nginx/ssl/frontend/star.iqoption.com.pem;
    ssl_certificate_key /etc/nginx/ssl/frontend/star.iqoption.com.key;
    access_log /var/log/nginx/new.iqoption.com_https_access.log main buffer=1m;
    include /etc/nginx/conf.d/upstreams_log;
#    include /etc/nginx/conf.d/static;
    include /etc/nginx/conf.d/favicon;
    include /etc/nginx/conf.d/locations_app_https_stage;
    include /etc/nginx/conf.d/locations_node_https_include;
#    include /etc/nginx/conf.d/locations_promo_http_include;
#    include /etc/nginx/conf.d/locations_static_https_include;
}