

    upstream authN-stg {
        server 10.0.40.10:3003;
        server 10.0.0.178:3003;
    }

    upstream ui-stg {
        server 10.0.40.10:3333;
        server 10.0.0.178:3333;
    }

    upstream apiplatform-stg {
        server 10.0.40.10:3000;
        server 10.0.0.178:3000;
    }

   upstream library-stg {
        server 54.85.199.148:8080;
    }

   upstream analytics {
        zone analytics 64k;
        server  stg-central-api-0.vpc.us-east-1a.stg.zzz.io:8081 resolve;
        server  stg-central-api-1.vpc.us-east-1a.stg.zzz.io:8081 resolve;
        server  stg-central-api-2.vpc.us-east-1a.stg.zzz.io:8081 resolve;
    }

   upstream ch_static_ui {
        zone ch_ui 64k;
        server ch-static-ui-files-stg.s3-website-us-east-1.amazonaws.com resolve;
    }

   upstream ch_console {
        zone ch_cons 64k;
        server console.vpc.us-east-1.stg.zzz.io:8080 resolve;
    }

    upstream hybrid {
         zone ch_hyb 64k;
         server hybrid-cons-i-234bc7cc.vpc.us-east-1b.stg.zzz.io:8080 resolve;
         server hybrid-cons-i-6247cd98.vpc.us-east-1a.stg.zzz.io:8080 resolve;
    }

server {
    listen 80;
    server_name stg.anypoint.mulesoft.com;
    proxy_intercept_errors on;
    #error_page 404 @notfound;
    #error_page 502 @apperror;
    error_page 503 @maintenance;

    error_log   /var/log/nginx/stg.anypoint_error.log;
    error_log  syslog:server=unix:/dev/log,facility=local6,tag=anypoint,severity=warn;
    access_log  /var/log/nginx/stg.anypoint_access.log main;
    access_log  syslog:server=unix:/dev/log,facility=local6,tag=anypoint,severity=warn main;


    # default AWS VPC DNS resolver endpoint
    root /var/www/nginx-default;

    proxy_set_header X-Real-IP  $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header Host $http_host;
    proxy_set_header X-Scheme $scheme;
    proxy_read_timeout 65;

    # default AWS VPC DNS resolver endpoint
    resolver 10.0.0.2 valid=60s;

    set $ch_console "console.vpc.us-east-1.stg.zzz.io";
    set $ch_static_ui "ch-static-ui-files-stg.s3-website-us-east-1.amazonaws.com";

    # Force HTTPS 
    if ($http_x_forwarded_proto != 'https') {
          # redirect to secure page [permanent | redirect]
          rewrite ^/(.*) https://$http_host$request_uri? permanent;
    }

    
    location / {
        proxy_pass https://ui-stg;
    }

# -------- accounts service ----------------------
    location /accounts {
        proxy_pass https://ui-stg/;
    }

    location /accounts/api {
        proxy_pass https://authN-stg/api;
    }

    location /accounts/oauth2 {
        proxy_pass https://authN-stg/oauth2;
    }

    location /accounts/login {
        proxy_pass https://authN-stg/login;
    }

    location /accounts/raml {
        proxy_pass https://authN-stg/raml;
    }

    location /accounts/support {
        proxy_pass  https://authN-stg/support;
    }

    location /accounts/logout {
        proxy_pass  https://authN-stg/logout;
    }
# -------- apiplatform service ----------------------
    location /apiplatform/ {
         proxy_pass http://apiplatform-stg/;
    }

    # library services
    location /library/ {
       proxy_pass              http://library-stg/;
    }

    location /exchange/ {
       proxy_pass              http://library-stg/;
    }

    # analytics
    location /analytics/ {
	    proxy_pass http://analytics;
    }

    # zzz services
    #location ~ ^/zzz {
    #    return 301 https://stg.zzz.io/login.html;
    #}


    # shared resources 
    location /shared/ {
       proxy_set_header Host ch-static-ui-files-stg.s3-website-us-east-1.amazonaws.com;
       proxy_hide_header "x-amz-id-2";
       proxy_hide_header "x-amz-meta-s3cmd-attrs";
       proxy_hide_header "x-amz-request-id";

       proxy_pass http://ch_static_ui/shared/; 
    }


    # zzz services
    location /zzz/ {
        proxy_set_header Host ch-static-ui-files-stg.s3-website-us-east-1.amazonaws.com;
        proxy_hide_header "x-amz-id-2";
        proxy_hide_header "x-amz-meta-s3cmd-attrs";
        proxy_hide_header "x-amz-request-id";

        proxy_pass http://ch_static_ui/ui-beta/;
    }

    location /zzz/api/ {
        limit_req zone=basic burst=15  nodelay;

        #proxy_pass http://$ch_console/api/;
        proxy_pass http://ch_console/api/;
    }

    location /zzz/web-api/ {
        limit_req zone=basic burst=15  nodelay;

        #proxy_pass http://$ch_console/web-api/;
        proxy_pass http://ch_console/web-api/;
     }

    # zzz-hybrid services
    location /hybrid/ {
        proxy_set_header Host ch-static-ui-files-stg.s3-website-us-east-1.amazonaws.com;
        proxy_hide_header "x-amz-id-2";
        proxy_hide_header "x-amz-meta-s3cmd-attrs";
        proxy_hide_header "x-amz-request-id";

        proxy_pass http://ch_static_ui/hybrid/;
    }

    location /hybrid/api/ {
       limit_req zone=basic burst=15  nodelay;

       proxy_pass http://hybrid/api/;
    }

    #location @notfound {
    #    rewrite (favicon.ico|cloud_background.png|img_logo.png|logo-zzz-190x58.png)$ /$1 break;
    #    rewrite ^(.*)$ /404.html break;
    #}

    location @maintenance {

        rewrite (favicon.ico|cloud_background.png|logo-zzz-190x58.png)$ /$1 break;
        try_files /maintenance.html /console_50x.html =503;
    }
    
    #location @apperror {
    #    rewrite (favicon.ico|cloud_background.png|img_logo.png|logo-zzz-190x58.png)$ /$1 break;
    #    rewrite ^(.*)$ /502.html break;
    #    return 502;
    #}

}

