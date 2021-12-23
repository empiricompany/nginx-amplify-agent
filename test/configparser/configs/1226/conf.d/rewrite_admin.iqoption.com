    location / {
        rewrite ^(.*)$ https://admin.iqoption.com$1;
    }
