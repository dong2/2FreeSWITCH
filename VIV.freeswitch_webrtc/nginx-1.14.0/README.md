```
[root@freeswitch ~]# yum install gcc-c++ pcre pcre-devel zlib zlib-devel #openssl openssl-devel
[root@freeswitch ~]# wget https://nginx.org/download/nginx-1.14.0.tar.gz
[root@freeswitch ~]# tar zxf nginx-1.14.0.tar.gz
[root@freeswitch ~]# cd nginx-1.14.0
[root@freeswitch ~]# ./configure --prefix=/usr/local/nginx --with-http_stub_status_module --with-http_ssl_module
[root@freeswitch ~]# make
[root@freeswitch ~]# make install
```
