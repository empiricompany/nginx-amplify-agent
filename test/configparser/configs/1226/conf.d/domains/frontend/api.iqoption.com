server {
    listen 206.54.170.38:80;
    listen 206.54.170.51:80;
    server_name api.iqoption.com;
    status_zone "api:api.iqoption.com";
    access_log /var/log/nginx/api.iqoption.com_http_access.log main;
    include /etc/nginx/conf.d/google_takeme;
    include /etc/nginx/conf.d/upstreams_log;
    include /etc/nginx/conf.d/favicon;
    include /etc/nginx/conf.d/locations_access_http_stage;
}
