server {
    listen 206.54.170.44:80;
    listen 206.54.170.57:80;
    server_name eu.iqoption.com;
    status_zone "web:eu.iqoption.com";
    access_log /var/log/nginx/iqoption.com_http_access.log main;
    include /etc/nginx/conf.d/google_takeme;
    include /etc/nginx/conf.d/rewrite_eu.iqoption.com;
}

server {
    listen 206.54.170.44:443 ssl;
    listen 206.54.170.57:443 ssl;
    server_name eu.iqoption.com;
    status_zone "web:eu.iqoption.com";
    include /etc/nginx/conf.d/include_ssl_sha2;
    ssl_certificate /etc/nginx/ssl/frontend/star.iqoption.com.pem;
    ssl_certificate_key /etc/nginx/ssl/frontend/star.iqoption.com.key;
    access_log /var/log/nginx/eu.iqoption.com_https_access.log main;
    include /etc/nginx/conf.d/upstreams_log;

#    include /etc/nginx/conf.d/static;
    include /etc/nginx/conf.d/favicon;
    include /etc/nginx/conf.d/locations_admin_https_include;
    include /etc/nginx/conf.d/locations_node_https_include;

    location /api/login {
        error_log /var/log/nginx/error.log crit;
        access_log /var/log/nginx/iqoption.com_https_api.log apilog;
        proxy_pass http://$my_upstream_https;
        include /etc/nginx/conf.d/proxy_pass_params;
        error_page 500 502 503 504 = @app_https;
    }
}