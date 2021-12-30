    location / {
        rewrite ^(.*)$ https://new.iqoption.com$1;
    }
