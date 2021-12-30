    location / {
        rewrite ^(.*)$ http://binaryobzor.com$1;
    }
