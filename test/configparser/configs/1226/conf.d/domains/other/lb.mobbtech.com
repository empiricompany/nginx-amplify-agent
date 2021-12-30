server {
    listen       78.140.140.166:80;
    listen       10.0.0.2:80;
    server_name wplb01.mobbtech.com lb01.sshd.in llb01.mobbtech.com llb01.sshd.in;
    status_zone "stats:lb01.mobbtech.com";

    access_log /var/log/nginx/lb1.mobbtech.com_access.log main buffer=1m;
    include /etc/nginx/conf.d/favicon;
    root /etc/nginx/misc/lb.mobbtech.com;
    if ( $internal_ip != "1" ) {
	rewrite ^/(.*)$  http://google.com/?q=%D0%BA%D0%B0%D0%BA-%D1%81%D1%8A%D0%B5%D0%B1%D0%B0%D1%82%D1%8C-%D0%B8%D0%B7.%D1%80%D1%84 last;
    }
    location / {
        try_files $uri /index.html;
    }

    location /status {
        status;
        access_log   off;
	allow all;
#        allow 127.0.0.1;
#        deny all;
    }

    location = /status.html {
        access_log   off;
	root /usr/share/nginx/html;
	allow all;
    }

    location /nginx_status {
        stub_status on;
        access_log   off;
        allow 127.0.0.1;
#        deny all;
    }
    location /upstream_conf {
        upstream_conf;
        allow 127.0.0.1;
#        deny all;
    }
}

server {
    listen       78.140.140.162:80;
    listen       10.0.0.1:80;
    server_name wplb02.mobbtech.com lb2.sshd.in llb02.mobbtech.com llb02.sshd.in;
    status_zone "stats:lb02.mobbtech.com";

    access_log /var/log/nginx/lb2.mobbtech.com_access.log main buffer=1m;
    include /etc/nginx/conf.d/favicon;
    root /etc/nginx/misc/lb.mobbtech.com;
    if ( $internal_ip != "1" ) {
	rewrite ^/(.*)$  http://google.com/?q=%D0%BA%D0%B0%D0%BA-%D1%81%D1%8A%D0%B5%D0%B1%D0%B0%D1%82%D1%8C-%D0%B8%D0%B7.%D1%80%D1%84 last;
    }
    location / {
        try_files $uri /index.html;
    }

    location /status {
        status;
        access_log   off;
	allow all;
#        allow 127.0.0.1;
#        deny all;
    }

    location = /status.html {
        access_log   off;
	root /usr/share/nginx/html;
	allow all;
    }

    location /nginx_status {
        stub_status on;
        access_log   off;
        allow 127.0.0.1;
#        deny all;
    }
    location /upstream_conf {
        upstream_conf;
        allow 127.0.0.1;
#        deny all;
    }

}

server {
    listen       206.54.170.34:80;
    listen       10.0.0.55:80;
    server_name wplb03.mobbtech.com lwplb03.mobbtech.com 10.0.0.55;
    status_zone "stats:wplb03.mobbtech.com";

    access_log /var/log/nginx/wplb03.mobbtech.com_access.log main buffer=1m;
    include /etc/nginx/conf.d/favicon;
    root /etc/nginx/misc/lb.mobbtech.com;
    if ( $internal_ip != "1" ) {
        rewrite ^/(.*)$  http://google.com/?q=%D0%BA%D0%B0%D0%BA-%D1%81%D1%8A%D0%B5%D0%B1%D0%B0%D1%82%D1%8C-%D0%B8%D0%B7.%D1%80%D1%84 last;
    }

    location / {
        try_files $uri /status.html;
    }

    location /status {
        status;
        access_log   off;
	allow all;
#        allow 127.0.0.1;
#        deny all;
    }

    location = /status.html {
        access_log   off;
	root /usr/share/nginx/html;
	allow all;
    }

    location /nginx_status {
        stub_status on;
        access_log   off;
        allow 127.0.0.1;
#        deny all;
    }
    location /upstream_conf {
        upstream_conf;
        allow 127.0.0.1;
#        deny all;
    }
}

server {
    listen       206.54.170.35:80;
    listen       10.0.0.56:80;
    server_name wplb04.mobbtech.com lwplb04.mobbtech.com 10.0.0.56;
    status_zone "stats:wplb04.mobbtech.com";

    access_log /var/log/nginx/wplb04.mobbtech.com_access.log main buffer=1m;
    include /etc/nginx/conf.d/favicon;
    root /etc/nginx/misc/lb.mobbtech.com;

    if ( $internal_ip != "1" ) {
        rewrite ^/(.*)$  http://google.com/?q=%D0%BA%D0%B0%D0%BA-%D1%81%D1%8A%D0%B5%D0%B1%D0%B0%D1%82%D1%8C-%D0%B8%D0%B7.%D1%80%D1%84 last;
    }
    location / {
        try_files $uri /status.html;
    }

    location /status {
        status;
        access_log   off;
	allow all;
#        allow 127.0.0.1;
#        deny all;
    }

    location = /status.html {
        access_log   off;
	root /usr/share/nginx/html;
	allow all;
    }

    location /nginx_status {
        stub_status on;
        access_log   off;
        allow 127.0.0.1;
#        deny all;
    }
    location /upstream_conf {
        upstream_conf;
        allow 127.0.0.1;
#        deny all;
    }
}

