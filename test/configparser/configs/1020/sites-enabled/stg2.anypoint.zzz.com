

    upstream ch_console_stg2 {
	server console.vpc.us-east-1.stg.zzz.io;
    }

    upstream ch_static_stg2 {
	server ch-static-ui-files-stg.s3-website-us-east-1.zzz.com;
    }
    

    upstream authserver-stg {
	server internal-authserver-1548-stg2-457685596.us-east-1.elb.zzz.com:3004;
    }

    upstream csui-stg {
        server internal-csui-1548-stg-896429561.us-east-1.elb.zzz.com:3334;
    }

    upstream apip-stg {
        server internal-apiplatform-1548-1959372564.us-east-1.elb.zzz.com:3000;
    }

server {
    listen 80;
    server_name stg2.anypoint.zzz.com;
    proxy_intercept_errors on;
    #error_page 404 @notfound;
    #error_page 502 @apperror;
    error_page 503 @maintenance;

    error_log   /var/log/nginx/stg2.anypoint_error.log;
    error_log  syslog:server=unix:/dev/log,facility=local6,tag=anypoint,severity=warn;
    access_log  /var/log/nginx/stg2.anypoint_access.log main;
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

    # Force HTTPS 
    if ($http_x_forwarded_proto != 'https') {
          # redirect to secure page [permanent | redirect]
          rewrite ^/(.*) https://$http_host$request_uri? permanent;
    }

    
    location / {
        proxy_pass http://csui-stg;
    }

# -------- accounts service ----------------------
    location /accounts {
        proxy_pass http://csui-stg/;
    }

    location /accounts/api {
        proxy_pass http://authserver-stg/api;
    }

    location /accounts/oauth2 {
        proxy_pass http://authserver-stg/oauth2;
    }

    location /accounts/login {
        proxy_pass http://authserver-stg/login;
    }

    location /accounts/raml {
        proxy_pass http://authserver-stg/raml;
    }

    location /accounts/support {
        proxy_pass  http://authserver-stg/support;
    }

# -------- apiplatform service ----------------------
    location /apiplatform/ {
         proxy_pass http://apip-stg/;
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

       proxy_set_header Host ch-static-ui-files-stg.s3-website-us-east-1.zzz.com;
       proxy_hide_header "x-amz-id-2";
       proxy_hide_header "x-amz-meta-s3cmd-attrs";
       proxy_hide_header "x-amz-request-id";

       proxy_pass http://ch_static_stg2/shared/; 
    }


    # zzz services
    location /zzz/ {
        proxy_set_header Host ch-static-ui-files-stg.s3-website-us-east-1.zzz.com;
        proxy_hide_header "x-amz-id-2";
        proxy_hide_header "x-amz-meta-s3cmd-attrs";
        proxy_hide_header "x-amz-request-id";

        proxy_pass http://ch_static_stg2/ui-beta/;
    }

    location /zzz/api/ {
        limit_req zone=basic burst=15  nodelay;

        #proxy_pass http://$ch_console/api/;
        proxy_pass http://ch_console_stg2/api/;
    }

    location /zzz/web-api/ {
        limit_req zone=basic burst=15  nodelay;

        #proxy_pass http://$ch_console/web-api/;
        proxy_pass http://ch_console_stg2/web-api/;
     }

    # zzz-hybrid services
    location /hybrid/ {
        proxy_set_header Host ch-static-ui-files-stg.s3-website-us-east-1.zzz.com;
        proxy_hide_header "x-amz-id-2";
        proxy_hide_header "x-amz-meta-s3cmd-attrs";
        proxy_hide_header "x-amz-request-id";

        proxy_pass http://ch_static_stg2/hybrid/;
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

