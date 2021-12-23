server {
    listen 206.54.170.46:80;
    listen 206.54.170.59:80;
    server_name api.new.iqoption.com;
    status_zone "api:api.new.iqoption.com";
    access_log /var/log/nginx/api.new.iqoption.com_http_access.log main buffer=1m;
    include /etc/nginx/conf.d/google_takeme;
    include /etc/nginx/conf.d/upstreams_log;
    include /etc/nginx/conf.d/favicon;
    include /etc/nginx/conf.d/locations_access_http_stage;
}
