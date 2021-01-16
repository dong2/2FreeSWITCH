### 添加openssl key
```
[root@freeswitch]wget http://files.freeswitch.org/downloads/ssl.ca-0.1.tar.gz
[root@freeswitch]tar zxfv ssl.ca-0.1.tar.gz
[root@freeswitch]cd ssl.ca-0.1/
[root@freeswitch ssl.ca-0.1]perl -i -pe 's/md5/sha256/g' *.sh
[root@freeswitch ssl.ca-0.1]perl -i -pe 's/1024/4096/g' *.sh
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


