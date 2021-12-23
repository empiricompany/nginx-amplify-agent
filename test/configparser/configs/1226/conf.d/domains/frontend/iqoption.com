server {
    listen 206.54.170.36:80;
    listen 206.54.170.49:80;
    server_name iqoption.com;
    status_zone "web:iqoption.com";
    access_log /var/log/nginx/iqoption.com_http_access.log main;
    include /etc/nginx/conf.d/google_takeme;
    include /etc/nginx/conf.d/rewrite_iqoption.com;
}

server {
    listen 206.54.170.36:443 ssl;
    listen 206.54.170.49:443 ssl;
    server_name iqoption.com;
    status_zone "web:iqoption.com";
    include /etc/nginx/conf.d/include_ssl;
    ssl_certificate /etc/nginx/ssl/frontend/iqoption.com.crt;
    ssl_certificate_key /etc/nginx/ssl/frontend/iqoption.com.key;
#    include /etc/nginx/conf.d/include_ssl_sha2;
#    ssl_certificate /etc/nginx/ssl/frontend/ev.iqoption.com.pem;
#    ssl_certificate_key /etc/nginx/ssl/frontend/ev.iqoption.com.key;
    access_log /var/log/nginx/iqoption.com_https_access.log main;
    include /etc/nginx/conf.d/upstreams_log;
#    include /etc/nginx/conf.d/static;
    include /etc/nginx/conf.d/favicon;
    include /etc/nginx/conf.d/locations_app_https_stage;
# enable /echo1 64k limited bandwitch
    include /etc/nginx/conf.d/locations_node1_https_include;
    include /etc/nginx/conf.d/locations_node_https_include;
    
    location /api/login {
        error_log /var/log/nginx/error.log crit;
        access_log /var/log/nginx/iqoption.com_https_api.log apilog;
        proxy_pass http://$my_upstream_https;
        include /etc/nginx/conf.d/proxy_pass_params;
        error_page 500 502 503 504 = @app_https;
    }
}