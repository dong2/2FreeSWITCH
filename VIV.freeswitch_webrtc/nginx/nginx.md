```
[root@freeswitch ~]# yum install gcc-c++ pcre pcre-devel zlib zlib-devel #openssl openssl-devel
[root@freeswitch ~]# wget https://nginx.org/download/nginx-1.14.0.tar.gz
[root@freeswitch ~]# tar zxf nginx-1.14.0.tar.gz
[root@freeswitch ~]# cd nginx-1.14.0
[root@freeswitch ~]# ./configure --prefix=/usr/local/nginx --with-http_stub_status_module --with-http_ssl_module
[root@freeswitch ~]# make
[root@freeswitch ~]# make install

[root@freeswitch ~]# vi /usr/local/nginx/conf/nginx.conf

    # HTTPS server
    #
    server {
        listen       443 ssl;
        server_name  localhost;

        ssl_certificate      SSL_Pub.pem;
        ssl_certificate_key  SSL_Priv.pem;

        ssl_session_cache    shared:SSL:1m;
        ssl_session_timeout  5m;

        ssl_ciphers  HIGH:!aNULL:!MD5;
        ssl_prefer_server_ciphers  on;

        location / {
            root   html;
            index  index.html index.htm;
        }

        location /sip {
            root /home;           
        }
    }

[root@freeswitch ~]# /usr/local/nginx/sbin/nginx -s quit
[root@freeswitch ~]# /usr/local/nginx/sbin/nginx -c /usr/local/nginx/conf/nginx.conf
[root@freeswitch ~]# /usr/local/nginx/sbin/nginx -s reload

```
