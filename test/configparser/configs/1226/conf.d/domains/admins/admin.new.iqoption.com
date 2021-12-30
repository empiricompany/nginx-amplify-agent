server {
	listen 206.54.170.48:80;
	listen 206.54.170.61:80;
	server_name admin.new.iqoption.com;

	access_log off;
	error_log off;

	location / {
		rewrite ^(.*)$ https://admin.new.iqoption.com$1;
	}

}

server {
    listen 206.54.170.48:443 ssl;
    listen 206.54.170.61:443 ssl;
    server_name admin.new.iqoption.com;
    status_zone "admin:admin.new.iqoption.com";
    include /etc/nginx/conf.d/include_ssl;
    ssl_certificate /etc/nginx/ssl/frontend/new.iqoption.com.crt;
    ssl_certificate_key /etc/nginx/ssl/frontend/new.iqoption.com.key;
    access_log /var/log/nginx/admin.new.iqoption.com_https_access.log main buffer=1m;
    include /etc/nginx/conf.d/upstreams_log;
    include /etc/nginx/conf.d/favicon;
    include /etc/nginx/conf.d/locations_admin_https_include;
}
