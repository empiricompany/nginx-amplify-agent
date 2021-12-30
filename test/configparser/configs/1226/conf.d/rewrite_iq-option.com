    location / {
        rewrite ^(.*)$ https://iq-option.com$1;
    }
