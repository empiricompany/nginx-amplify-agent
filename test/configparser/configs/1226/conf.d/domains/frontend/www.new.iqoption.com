server {
    listen  206.54.170.62:80;
    server_name www.new.iqoption.com;
    status_zone "web:www.new.iqoption.com";
    access_log off;
#    error_log off;
    include /etc/nginx/conf.d/rewrite_new.iqoption.com;
}
