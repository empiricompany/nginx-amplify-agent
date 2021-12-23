server {
    listen 206.54.170.37:80;
    listen 206.54.170.50:80;
    server_name m.iqoption.com;
    status_zone "mobile:m.iqoption.com";
    access_log /var/log/nginx/m.iqoption.com_http_access.log main;
    include /etc/nginx/conf.d/google_takeme;
    include /etc/nginx/conf.d/rewrite_m.iqoption.com;
}

server {
    listen 206.54.170.37:443 ssl;
    listen 206.54.170.50:443 ssl;
    server_name m.iqoption.com;
    status_zone "mobile:m.iqoption.com";
    include /etc/nginx/conf.d/include_ssl;
    ssl_certificate /etc/nginx/ssl/frontend/m.iqoption.com.crt;
    ssl_certificate_key /etc/nginx/ssl/frontend/m.iqoption.com.key;
#    include /etc/nginx/conf.d/include_ssl_sha2;
#    ssl_certificate /etc/nginx/ssl/frontend/star.iqoption.com.pem;
#    ssl_certificate_key /etc/nginx/ssl/frontend/star.iqoption.com.key;
    access_log /var/log/nginx/m.iqoption.com_https_access.log main;
    include /etc/nginx/conf.d/upstreams_log;
#    include /etc/nginx/conf.d/static;
    include /etc/nginx/conf.d/favicon;
    include /etc/nginx/conf.d/locations_app_https_include;
    include /etc/nginx/conf.d/locations_node_https_include;
    #include /etc/nginx/conf.d/locations_main_include_with_go;
}