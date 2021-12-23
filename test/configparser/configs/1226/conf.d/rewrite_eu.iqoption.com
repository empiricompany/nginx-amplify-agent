    location / {
        error_log /var/log/nginx/error.log crit;
        try_files $uri $geo_eu_list;
    }

    location @non_eu {
        rewrite ^(.*)$ https://iqoption.com$1;
    }

    location @is_eu {
        rewrite ^(.*)$ https://eu.iqoption.com$1;
    }
