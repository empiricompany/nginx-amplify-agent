    location / {
            rewrite ^(.*)$ https://new-admin.iqoption.com$1;
    }
