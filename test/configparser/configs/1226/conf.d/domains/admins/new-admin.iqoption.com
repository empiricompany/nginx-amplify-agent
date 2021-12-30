server {
    listen 206.54.170.42:80;
    listen 206.54.170.55:80;
    server_name new-admin.iqoption.com;
    status_zone "admin:new-admin.iqoption.com";
    access_log /var/log/nginx/new-admin.iqoption.com_http_access.log main;
    include /etc/nginx/conf.d/google_takeme;
    include /etc/nginx/conf.d/upstreams_log;
#    include /etc/nginx/conf.d/static;
    include /etc/nginx/conf.d/favicon;
    include /etc/nginx/conf.d/locations_admin_http_include;
    include /etc/nginx/conf.d/locations_node_https_include;
#    #include /etc/nginx/conf.d/locations_main_include_with_go;
}

