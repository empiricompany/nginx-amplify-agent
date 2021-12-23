server {
    listen 206.54.170.40:80;
    listen 206.54.170.53:80;
    server_name www.iqoption.com www.iqoption.ru iqoption.ru www.iqoptions.ru iqoptions.ru;
    status_zone "web:www.iqoption.com";
    access_log off;
#    error_log off;
    include /etc/nginx/conf.d/rewrite_iqoption.com;
}

server {
    listen 206.54.170.40:443 ssl;
    listen 206.54.170.53:443 ssl;
    server_name www.iqoption.com;
    status_zone "web:www.iqoption.com";
    include /etc/nginx/conf.d/include_ssl;
    ssl_certificate /etc/nginx/ssl/frontend/www.iqoption.com.crt;
    ssl_certificate_key /etc/nginx/ssl/frontend/www.iqoption.com.key;
#    include /etc/nginx/conf.d/include_ssl_sha2;
#    ssl_certificate /etc/nginx/ssl/frontend/ev.iqoption.com.pem;
#    ssl_certificate_key /etc/nginx/ssl/frontend/ev.iqoption.com.key;
    access_log /var/log/nginx/www.iqoption.com_https_access.log main;
#    access_log off;
#    error_log off;
    include /etc/nginx/conf.d/rewrite_iqoption.com;
}