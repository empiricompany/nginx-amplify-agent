server {
	listen 206.54.170.39:80;
	listen 206.54.170.52:80;
	server_name admin.iqoption.com;
	status_zone "admin:admin.iqoption.com";

	access_log off;
	error_log off;

	location / {
		rewrite ^(.*)$ https://admin.iqoption.com$1;
	}

}

server {
    listen 206.54.170.39:443 ssl;
    listen 206.54.170.52:443 ssl;
    server_name admin.iqoption.com;
    status_zone "admin:admin.iqoption.com";
#    include /etc/nginx/conf.d/include_ssl;
#    ssl_certificate /etc/nginx/ssl/admins/admin.iqoption.com.crt;
#    ssl_certificate_key /etc/nginx/ssl/admins/admin.iqoption.com.key;
    include /etc/nginx/conf.d/include_ssl_sha2;
    ssl_certificate /etc/nginx/ssl/frontend/star.iqoption.com.pem;
    ssl_certificate_key /etc/nginx/ssl/frontend/star.iqoption.com.key;
    access_log /var/log/nginx/admin.iqoption.com_https_access.log main;
    include /etc/nginx/conf.d/upstreams_log;
#    include /etc/nginx/conf.d/static;
    include /etc/nginx/conf.d/favicon;
    include /etc/nginx/conf.d/locations_admin_https_include;
    include /etc/nginx/conf.d/locations_node_https_include;
    #include /etc/nginx/conf.d/locations_main_include_with_go;
}