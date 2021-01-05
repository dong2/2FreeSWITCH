```
[root@freeswitch ~]# yum install gcc-c++ pcre pcre-devel zlib zlib-devel #openssl openssl-devel
[root@freeswitch ~]# wget https://nginx.org/download/nginx-1.14.0.tar.gz
[root@freeswitch ~]# tar zxf nginx-1.14.0.tar.gz
[root@freeswitch ~]# cd nginx-1.14.0
[root@freeswitch ~]# ./configure --prefix=/usr/local/nginx --with-http_stub_status_module --with-http_ssl_module
[root@freeswitch ~]# make
[root@freeswitch ~]# make install


/usr/local/nginx/sbin/nginx -s quit
/usr/local/nginx/sbin/nginx -c /usr/local/nginx/conf/nginx.conf
/usr/local/nginx/sbin/nginx -s reload


# 一般情况不配置ssl_protocols，默认状态是
ssl_protocols SSLv3 TLSv1 TLSv1.1 TLSv1.2;

# 禁止SSLv3
ssl_protocols TLSv1 TLSv1.1 TLSv1.2;

# 没有禁止SSLv3,但是去掉了CBC算法
ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-RSA-RC4-SHA:AES128-GCM-SHA256:AES128-SHA256:AES128-SHA:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:AES256-GCM-SHA384:AES256-SHA256:AES256-SHA:ECDHE-RSA-AES128-SHA256:RC4-SHA:!aNULL:!eNULL:!EXPORT:!DES:!3DES:!MD5:!DSS:!PKS;
```
