# openssl genrsa -des3 -out tmp.key 2048

# openssl rsa -in tmp.key -out server.key

# rm -f tmp.key

# openssl req -new -key server.key -out server.csr

# openssl x509 -req -days 3650 -in server.csr -signkey server.key -out server.crt


./configure --prefix=/usr/local/nginx --with-http_stub_status_module --with-http_ssl_module --with-http_v2_module

/usr/local/nginx/sbin/nginx -s quit
/usr/local/nginx/sbin/nginx -c /usr/local/nginx/conf/nginx.conf



https://baijiahao.baidu.com/s?id=1649462735958571118&wfr=spider&for=pc
https://blog.csdn.net/huang714/article/details/104748829
https://www.cnblogs.com/fivedragon/p/3997469.html
