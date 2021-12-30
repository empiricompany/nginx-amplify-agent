
    upstream accounts-uat {
        server 127.0.0.1:80;
    }

    upstream authN {
        server 10.0.0.155:3003;
    }

    upstream ui {
        server 10.0.0.155:3333;
    }

    upstream apiplatform-uat {
        server 10.0.0.155:80;
    }

   upstream library {
        server 54.86.13.233:8080;
    }

server {
    listen 80;
    server_name uat.anypoint.zzz.com;
#    proxy_intercept_errors on;
#    error_page 404 @notfound;
#    error_page 503 @maintenance;

    error_log  /var/log/nginx/uat-anypoint_error.log;
    error_log  syslog:server=unix:/dev/log,facility=local6,tag=uatanypoint,severity=warn;
    access_log /var/log/nginx/uat-anypoint_access.log main;
    access_log syslog:server=unix:/dev/log,facility=local6,tag=uatanypoint,severity=warn main;

    # default AWS VPC DNS resolver endpoint
    #resolver 10.0.0.2 valid=60s;
    #root /var/www/nginx-default;

    proxy_set_header X-Real-IP  $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header Host $http_host;
    proxy_set_header X-Scheme $scheme;
    proxy_read_timeout 65;

    return 301 https://anypoint.zzz.com;

#    # account services
#    location /accounts/ {
#        proxy_set_header Host "accounts-uat.anypoint.zzz.com";
#        proxy_pass http://accounts-uat/;
#    }
#
#    # apiplatform services
#    location /apiplatform/ {
#         proxy_pass http://apiplatform-uat/;
#    }
#
#    # library services
#    location /library/ {
#        proxy_pass http://library/;
#    }
#    
#    # analytics
#    location /analytics/ {
#        proxy_pass http://mule-analytics-api-dev.ifar.io/analytics/;
#    }
#
#    # zzz services
#    location /zzz/ {
#        return 301 https://stg.zzz.io/login.html;
#    }

}



server {
    listen 80;
    server_name apiplatform-uat.anypoint.zzz.com;
#    proxy_intercept_errors on;
#    error_page 404 @notfound;
#    error_page 503 @maintenance;

    error_log  /var/log/nginx/apiplatform-uat-anypoint_error.log;
    error_log  syslog:server=unix:/dev/log,facility=local6,tag=apiplatform,severity=warn;
    access_log /var/log/nginx/apiplatform-uat-anypoint_access.log main;
    access_log syslog:server=unix:/dev/log,facility=local6,tag=apiplatform,severity=warn main;

    # default AWS VPC DNS resolver endpoint
    #resolver 10.0.0.2 valid=60s;
    #root /var/www/nginx-default;

    proxy_set_header X-Real-IP  $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header Host $http_host;
    proxy_set_header X-Scheme $scheme;
    proxy_read_timeout 65;

    return 301 https://anypoint.zzz.com/apiplatform/;

#    # apiplatform services
#    location / {
#        proxy_pass http://apiplatform-uat;
#    }

}


server {
    listen 80;
    server_name accounts-uat.anypoint.zzz.com;
#    proxy_intercept_errors on;
#    error_page 404 @notfound;
#    error_page 503 @maintenance;

    error_log  /var/log/nginx/accounts-uat-anypoint_error.log;
    error_log  syslog:server=unix:/dev/log,facility=local6,tag=accounts,severity=warn;
    access_log /var/log/nginx/accounts-uat-anypoint_access.log main;
    access_log syslog:server=unix:/dev/log,facility=local6,tag=accounts,severity=warn main;

    access_log /var/log/nginx/accounts-access.log;
    error_log /var/log/nginx/accounts-error.log;


    # default AWS VPC DNS resolver endpoint
    #resolver 10.0.0.2 valid=60s;

    proxy_set_header X-Real-IP  $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header Host $http_host;
    proxy_set_header X-Scheme $scheme;

    proxy_read_timeout 65;
    root /var/www/nginx-default;

    return 301 https://anypoint.zzz.com;

#    # AuthN (Authentication Server)
#    #
#    location /api/ {
#        proxy_pass https://authN;
#    }
#
#    location /oauth2 {
#        proxy_pass https://authN;
#    }
#
#    location /login {
#        proxy_pass https://authN;
#    }
#
#    location /raml/ {
#        proxy_pass https://authN;
#    }
#
#    # UI
#    #
#    location / {
#        proxy_pass https://ui;
#    }

}
