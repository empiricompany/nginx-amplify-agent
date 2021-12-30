    location / {
        rewrite ^(.*)$ https://m.iqoption.com$1;
    }
