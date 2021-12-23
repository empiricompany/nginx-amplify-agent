server {
  listen   80;
  server_name  crl.alphassl.com;

  access_log  /var/log/nginx/gscrl0.access.log;

  location / {
    root   /data/nginx/crl;
    autoindex off;
    #expires 3h;
    index  index.html index.htm;
    include /etc/nginx/crl-cache-headers.conf;
  }
}
