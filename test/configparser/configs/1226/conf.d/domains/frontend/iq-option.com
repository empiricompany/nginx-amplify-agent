server {
    listen 206.54.170.47:80;
    listen 206.54.170.60:80;
    server_name iq-option.com;
    status_zone "other:iq-option.com";
    access_log /var/log/nginx/iq-option.com_http_access.log main buffer=1m;
    include /etc/nginx/conf.d/google_takeme;
    include /etc/nginx/conf.d/upstreams_log;
#    include /etc/nginx/conf.d/static;
#    include /etc/nginx/conf.d/favicon;
    include /etc/nginx/conf.d/rewrite_iq-option.com;
}

server {
    listen 206.54.170.47:443 ssl;
    listen 206.54.170.60:443 ssl;
    server_name iq-option.com;
    status_zone "other:iq-option.com";
    include /etc/nginx/conf.d/include_ssl_sha2;
    ssl_certificate /etc/nginx/ssl/frontend/iq-option.com.crt;
    ssl_certificate_key /etc/nginx/ssl/frontend/iq-option.com.key;

    access_log /var/log/nginx/iq-option.com_https_access.log main buffer=1m;
    include /etc/nginx/conf.d/upstreams_log;
#    include /etc/nginx/conf.d/static;
    include /etc/nginx/conf.d/favicon;
    include /etc/nginx/conf.d/locations_app_https_include;
    include /etc/nginx/conf.d/locations_node_https_include;
    #include /etc/nginx/conf.d/locations_main_include_with_go;
}