
https://zhuanlan.zhihu.com/p/80936998



# coturn
sudo yum install coturn/sudo apt-get install coturn
sudo openssl rand -hex 32
9e3e9be0e0947c2a519e75e048d884f736c4cd31e6e78c60247e62cbf06de33b
vi /etc/coturn/turnserver.conf


cipher-list="ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:ECDH+3DES:DH+3DES:RSA+AES:RSA+3DES:!ADH:!AECDH:!MD5"


ssl_certificate     /home/x_user/https/3700700_info.test.com.pem;  # pem文件的路径
ssl_certificate_key  /home/x_user/https/3700700_info.test.com.key; # key文件的路径

# ssl验证相关配置
ssl_session_timeout  5m;    #缓存有效期
ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE:ECDH:AES:HIGH:!NULL:!aNULL:!MD5:!ADH:!RC4;    #加密算法
ssl_protocols TLSv1 TLSv1.1 TLSv1.2;    #安全链接可选的加密协议
ssl_prefer_server_ciphers on;   #使用服务器端的首选算法









