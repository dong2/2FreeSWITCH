----------------------------------------------------------------------------------  
  
freeswitch + linphone + sipml5 over ws  

### 注意：
替换1.conf.public.basic整个目录到/usr/local/freeswitch/conf, 重启freeswitch即可  

1. Linphone on android 默认的设置里有个AVPF选项必须取消启动
2. Linphone on windows 设置里的AVPF选项默认是未启动的
3. sipml5 在firefox http://localhost下与各软电话能正常互拨通话

----------------------------------------------------------------------------------  

freeswitch + linphone + sipml5 over wss  
  
### 添加配置
vi conf/vars.xml
```
  <!-- Internal SIP Profile -->
  <X-PRE-PROCESS cmd="set" data="internal_auth_calls=true"/>
  <X-PRE-PROCESS cmd="set" data="internal_sip_port=15060"/>
  <X-PRE-PROCESS cmd="set" data="internal_tls_port=15061"/>
  <X-PRE-PROCESS cmd="set" data="internal_ssl_enable=true"/>

  <!-- External SIP Profile -->
  <X-PRE-PROCESS cmd="set" data="external_auth_calls=true"/>
  <X-PRE-PROCESS cmd="set" data="external_sip_port=15080"/>
  <X-PRE-PROCESS cmd="set" data="external_tls_port=15081"/>
  <X-PRE-PROCESS cmd="set" data="external_ssl_enable=true"/>
```

vi conf/sip_profiles/internal.xml
```
  <param name="ws-binding"  value=":5066"/>

  <param name="tls-cert-dir" value="/usr/local/freeswitch/certs"/>
  <param name="wss-binding" value=":7443"/>
```

### 添加openssl key
```
[root@freeswitch ssl.ca-0.1]# openssl genrsa -des3 -out ca.key 4096
Generating RSA private key, 4096 bit long modulus (2 primes)
.................................................................................................................................................++++
..................++++
e is 65537 (0x010001)
Enter pass phrase for ca.key:
Verifying - Enter pass phrase for ca.key:

[root@freeswitch ssl.ca-0.1]# ls
ca.key  COPYING  new-root-ca.sh  new-server-cert.sh  new-user-cert.sh  p12.sh  random-bits  README  sign-server-cert.sh  sign-user-cert.sh  VERSION

[root@freeswitch ssl.ca-0.1]# ./new-root-ca.sh 
Self-sign the root CA...
Enter pass phrase for ca.key:
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [MY]:CN
State or Province Name (full name) [Perak]:GD
Locality Name (eg, city) [Sitiawan]:GZ
Organization Name (eg, company) [My Directory Sdn Bhd]:ZHD
Organizational Unit Name (eg, section) [Certification Services Division]:RD
Common Name (eg, MD Root CA) []:zhoudd
Email Address []:15019442511@126.com

[root@freeswitch ssl.ca-0.1]# ./new-server-cert.sh  server
No server.key round. Generating one
Generating RSA private key, 4096 bit long modulus (2 primes)
.......................................++++
..................++++
e is 65537 (0x010001)

Fill in certificate data
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [MY]:CN
State or Province Name (full name) [Perak]:GD
Locality Name (eg, city) [Sitiawan]:GZ
Organization Name (eg, company) [My Directory Sdn Bhd]:ZHD
Organizational Unit Name (eg, section) [Secure Web Server]:RD
Common Name (eg, www.domain.com) []:8.134.56.226
Email Address []:15019442511@126.com

You may now run ./sign-server-cert.sh to get it signed

[root@freeswitch ssl.ca-0.1]# ./sign-server-cert.sh server
CA signing: server.csr -> server.crt:
Using configuration from ca.config
Enter pass phrase for ./ca.key:
Check that the request matches the signature
Signature ok
The Subject's Distinguished Name is as follows
countryName           :PRINTABLE:'CN'
stateOrProvinceName   :PRINTABLE:'GD'
localityName          :PRINTABLE:'GZ'
organizationName      :PRINTABLE:'ZHD'
organizationalUnitName:PRINTABLE:'RD'
commonName            :PRINTABLE:'8.134.56.226'
emailAddress          :IA5STRING:'15019442511@126.com'
Certificate is to be certified until Dec 18 09:25:50 2021 GMT (365 days)
Sign the certificate? [y/n]:y


1 out of 1 certificate requests certified, commit? [y/n]y
Write out database with 1 new entries
Data Base Updated
CA verifying: server.crt <-> CA cert
server.crt: OK

[root@freeswitch ssl.ca-0.1]# ls -l
总用量 104
-rw-r--r-- 1 root root  2029 12月 18 17:23 ca.crt
drwxr-xr-x 2 root root  4096 12月 18 17:25 ca.db.certs
-rw-r--r-- 1 root root   106 12月 18 17:25 ca.db.index
-rw-r--r-- 1 root root    21 12月 18 17:25 ca.db.index.attr
-rw-r--r-- 1 root root     3 12月 18 17:25 ca.db.serial
-rw------- 1 root root  3311 12月 18 17:22 ca.key
-rw-r--r-- 1  500  500 17992 4月  24 2000 COPYING
-rwxr-xr-x 1  500  500  1460 12月 18 17:10 new-root-ca.sh
-rwxr-xr-x 1  500  500  1539 12月 18 17:10 new-server-cert.sh
-rwxr-xr-x 1  500  500  1049 12月 18 17:10 new-user-cert.sh
-rwxr-xr-x 1  500  500   984 12月 18 17:10 p12.sh
-rw-r--r-- 1  500  500  1024 4月  23 2000 random-bits
-rw-r--r-- 1  500  500 11503 4月  24 2000 README
-rw-r--r-- 1 root root  7268 12月 18 17:25 server.crt
-rw-r--r-- 1 root root  1793 12月 18 17:24 server.csr
-rw------- 1 root root  3243 12月 18 17:23 server.key
-rwxr-xr-x 1  500  500  2082 12月 18 17:10 sign-server-cert.sh
-rwxr-xr-x 1  500  500  1918 12月 18 17:10 sign-user-cert.sh
-rw-r--r-- 1  500  500    50 4月  24 2000 VERSION
 
[root@freeswitch ssl.ca-0.1]# cat server.crt server.key > /usr/local/freeswitch/certs/wss.pem
[root@freeswitch ssl.ca-0.1]# cat server.crt server.key > /usr/local/freeswitch/certs/agent.pem
[root@freeswitch ssl.ca-0.1]# cat ca.crt > /usr/local/freeswitch/certs/cafile.pem
[root@freeswitch ssl.ca-0.1]# cat server.crt > /usr/local/freeswitch/certs/dtls-srtp.crt

[root@freeswitch ssl.ca-0.1]# cat server.crt > /usr/local/nginx/conf/server.crt
[root@freeswitch ssl.ca-0.1]# cat server.key > /usr/local/nginx/conf/server.key
[root@freeswitch ssl.ca-0.1]# cat ca.crt > /usr/local/nginx/conf/ca.crt

[root@freeswitch ssl.ca-0.1]# /usr/local/nginx/sbin/nginx -s quit
[root@freeswitch ssl.ca-0.1]# /usr/local/nginx/sbin/nginx -c /usr/local/nginx/conf/nginx.conf

[root@freeswitch ssl.ca-0.1]# freeswitch -nonat -nonatmap -nosql
```

1. fs Certificates
https://freeswitch.org/confluence/display/FREESWITCH/WebRTC#WebRTC-InstallCertificates
2. freeswitch使用自签证书,配置WSS
https://blog.csdn.net/weixin_42275389/article/details/89183536

