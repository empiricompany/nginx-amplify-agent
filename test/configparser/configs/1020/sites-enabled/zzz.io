server { # resolver configuration to proxy to mule workers
    listen 80;
    server_name *.stg.zzz.io;

    error_log  /var/log/nginx/stg-muleworkers_error.log;
    error_log  syslog:server=unix:/dev/log,facility=local6,tag=muleworkers,severity=warn;
    access_log /var/log/nginx/stg-muleworkers_access.log main;
    access_log syslog:server=unix:/dev/log,facility=local6,tag=muleworkers,severity=warn main;

    error_page 404 @notfound;
    error_page 502 @apperror;
    include /etc/nginx/chunkin.conf;

    keepalive_timeout    60;

    # resolve directly against nameservers for dns zone to avoid caching
    resolver ns-1262.awsdns-29.org ns-592.awsdns-10.net ns-318.awsdns-39.com ns-1949.awsdns-51.co.uk;

    location / {
        include /etc/nginx/proxy.conf;
        proxy_http_version 1.1;
        proxy_set_header Connection "";
        proxy_keepalive 10;
        proxy_ssl_session_cache 100;
        proxy_ssl_protocols SSLv3 TLSv1;

        if ($http_x_forwarded_proto = 'https') {
            proxy_pass https://mule-worker-$host:8082$request_uri;
            break;
        }
        proxy_pass http://mule-worker-$host:8081$request_uri;
    }

    location @notfound {
        root   /var/www/nginx-default;
        rewrite (favicon.ico|cloud_background.png|img_logo.png|logo-zzz-190x58.png)$ /$1 break;
        rewrite ^(.*)$ /404.html break;
    }
    location @apperror {
        root   /var/www/nginx-default;
        rewrite (favicon.ico|cloud_background.png|img_logo.png|logo-zzz-190x58.png)$ /$1 break;
        rewrite ^(.*)$ /502.html break;
        return 502;
    }
}

server { # simple reverse-proxy
    server_name stg.zzz.io www.stg.zzz.io;
    listen 80 default;

    error_log  /var/log/nginx/stg-zzz_error.log;
    error_log  syslog:server=unix:/dev/log,facility=local6,tag=zzz,severity=warn;
    access_log /var/log/nginx/stg-zzz_access.log main;
    access_log syslog:server=unix:/dev/log,facility=local6,tag=zzz,severity=warn main;

    # Removing timeout for big file uploads
    #include /etc/nginx/proxy.conf;
    root /var/www/nginx-default;
    proxy_intercept_errors on;
    error_page 404 500 502 504 @error;
    error_page 503 @maintenance;

    # default AWS VPC DNS resolver endpoint
    resolver 10.0.0.2 valid=60s;

    # Information Leakage :: #67989359
    add_header X-Frame-Options SAMEORIGIN;
    set $backend "console.vpc.us-east-1.stg.zzz.io";
    set $static "ch-static-ui-files-stg.s3-website-us-east-1.amazonaws.com";

    location  /login.html {
        return 301  https://stg.anypoint.mulesoft.com/accounts/;
    }

    location  /signup.html {
        return 301 https://stg.anypoint.mulesoft.com/#/signup?apintent=zzz; 
    }

    location / {
        include sites-enabled/zzz.io-blacklist;

        proxy_set_header X-Real-IP  $remote_addr;
        proxy_set_header Host $http_host;
        proxy_set_header X-Forwarded-Proto-Real $http_x_forwarded_proto;

        if ($uri = /) {
            rewrite ^ http://mulesoft.com/zzz/ipaas-cloud-based-integration-demand redirect;
        }
        if ($http_x_forwarded_proto != 'https') {
            # redirect to secure page [permanent | redirect]
            rewrite ^/(.*) https://$http_host$request_uri? permanent;
        }

        if (-f $document_root/maintenance.html) {
                return 503;
        }

        proxy_pass http://$backend:8080$request_uri;
    }

    location  /ui-beta/ {
        include sites-enabled/zzz.io-blacklist;

        if ($http_x_forwarded_proto != 'https') {
    	    # redirect to secure page [permanent | redirect]
    	    rewrite ^/(.*) https://$http_host$request_uri? permanent;
        }
	      
	    if (-f $document_root/maintenance.html) {
                return 503;
        }

        proxy_pass http://$static:80$request_uri;
    }

    location ~ ^((/api/)|(/web-api/)) {
        include sites-enabled/zzz.io-blacklist;

        limit_req   zone=basic burst=15  nodelay;

        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header Host $http_host;
        proxy_set_header X-Forwarded-Proto-Real $http_x_forwarded_proto;

        if ($http_x_forwarded_proto != 'https') {
    	    # redirect to secure page [permanent | redirect]
    	    rewrite ^/(.*) https://stg.zzz.io$request_uri? permanent;
        }

        proxy_pass http://$backend:8080$request_uri;

    }

    location @error {
        # to properly send custom 500 error page for POST request
        # we need to implement a POST to static conversion. Return 500 for now
        if ($request_method = POST ) { return 500; }

        include error_proxies.conf;
        rewrite (favicon.ico|cloud_background.png|img_logo.png|logo-zzz-190x58.png)$ /$1 break;
        rewrite ^(.*)$ /console_50x.html break;
    }

    location @maintenance {
         include error_proxies.conf;
         rewrite (favicon.ico|cloud_background.png|logo-zzz-190x58.png)$ /$1 break;
         try_files /maintenance.html /console_50x.html =503;
    }
}

