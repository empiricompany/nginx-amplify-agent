server { # simple reverse-proxy
    listen 80;
    server_name stage.zzz.io
    proxy_intercept_errors on;
    error_page 404 @notfound;
    error_page 503 @maintenance;

    error_log  /var/log/nginx/zzz_error.log;
    error_log  syslog:server=unix:/dev/log,facility=local6,tag=zzz,severity=warn;
    access_log /var/log/nginx/zzz_access.log main;
    access_log syslog:server=unix:/dev/log,facility=local6,tag=zzz,severity=warn main;

    # default AWS VPC DNS resolver endpoint
    resolver 10.0.0.2 valid=60s;

    proxy_set_header  X-Real-IP  $remote_addr;
    proxy_set_header Host $http_host;

    proxy_read_timeout 360;
    proxy_connect_timeout 10;
    root /var/www/html-zzz;

    include chunkin.conf;

    set $dl_backend "mule-worker-zzz-stg.stg.zzz.io";

    location @notfound {
        include error_proxies.conf;
        rewrite (favicon.ico|mulesoft-logo-footer.png|img_logo.png|logo-zzzio.png)$ /img/$1 break;
        try_files /404.html =404;
    }

    location @maintenance {
         include error_proxies.conf;
         rewrite (favicon.ico|mulesoft-logo-footer.png|logo-zzzio.png)$ /img/$1 break;
         try_files /maintenance.html =503;
    }

    location / {
            if (-f $document_root/maintenance.html) {
                return 503;
            }

            if ($uri = /) {
                rewrite ^ https://stage.zzz.io/static/ redirect;
            }

            proxy_read_timeout 360;
            proxy_pass https://$dl_backend:8082$request_uri;
    }


}
