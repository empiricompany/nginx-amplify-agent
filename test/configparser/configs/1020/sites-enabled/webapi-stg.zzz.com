server {
    listen 80;
    server_name webapi-stg.zzz.com webapi.cisco.com;
    proxy_intercept_errors on;
    #error_page 404 @notfound;
    #error_page 502 @apperror;
    error_page 503 @maintenance;

    error_log   /var/log/nginx/webapi-stg.zzz.com_error.log;
    error_log  syslog:server=unix:/dev/log,facility=local6,tag=cisco,severity=warn;
    access_log  /var/log/nginx/webapi-stg.zzz.com_access.log main;
    access_log  syslog:server=unix:/dev/log,facility=local6,tag=cisco,severity=warn main;


    # default AWS VPC DNS resolver endpoint
    root /var/www/webapi.cisco.com;

    # default AWS VPC DNS resolver endpoint
    resolver 10.0.0.2 valid=60s;

}

