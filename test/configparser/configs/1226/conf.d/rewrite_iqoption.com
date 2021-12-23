    location / {
        rewrite ^(.*)$ https://iqoption.com$1;
    }
