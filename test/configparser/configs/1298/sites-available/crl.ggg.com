server {
  listen   80;
  server_name  crl.aaa.com;
  server_name  crl.origin.aaa.com;

  access_log  /var/log/nginx/crl.access.log;

  location / {
    root  /data/nginx/crl.globalsign.com;
    #autoindex on;
    autoindex off;
    #expires 3h;
    #index  index.html index.htm;
    include /etc/nginx/crl-cache-headers.conf;
  }
}
