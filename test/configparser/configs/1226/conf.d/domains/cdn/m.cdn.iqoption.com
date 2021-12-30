server {
    listen 206.54.170.41:80;
    listen 206.54.170.54:80;
    server_name m.cdn.iqoption.com;
    status_zone "cdn:m.cdn.iqoption.com";
    access_log /var/log/nginx/m.cdn.iqoption.com_http_access.log main;
    include /etc/nginx/conf.d/google_takeme;
    access_log /var/log/nginx/upstreamc.log upstream;
#    include /etc/nginx/conf.d/upstreams_log;
#    include /etc/nginx/conf.d/static;
    include /etc/nginx/conf.d/favicon;
#    include /etc/nginx/conf.d/locations_static_http_include;
    include /etc/nginx/conf.d/locations_app_http_include;
#    include /etc/nginx/conf.d/locations_promo_http_include;
#    include /etc/nginx/conf.d/rewrite_iqoption.com;
}
