###  FreeSwitch_Install_Certificates
```

Antonio 发表：

hi,

after install, the default wss.pem gives error, so to test verto communicator with a custom certificate (i think this info is around here) if testing in local without a public domain to use lets encrypt:

mkdir /root/ssl

cd /root/ssl

openssl req -newkey rsa:2048 -nodes -keyout key.pem -x509 -days 365 -out certificate.pem

#TIP: put in common name the ip address, so when testing you only have the warning for invalid

cat key.pem certificate.pem > /usr/local/freeswitch/certs/wss.pem

 

#enable or replace in nginx ssl options for /etc/nginx/sites-enabled/default

ssl_certificate /root/ssl/certificate.pem;

ssl_certificate_key /root/ssl/key.pem;

 

#vc into www,

cp -a /usr/src/freeswitch/html5/verto/verto_communicator/dist/* /var/www/html/

 

hope it helps others (微笑)

    Fran Vicente赞了它
    2018.02.07
```


notice:
```
WebRTC does not work properly with self–signed certs. Chrome will not even tell you why when it refuses them. This is why a proper certificate is essential even when testing WebRTC. See Let's Encrypt above.
``
https://freeswitch.org/confluence/display/FREESWITCH/Certificates
https://freeswitch.org/confluence/display/FREESWITCH/SIP+TLS
https://freeswitch.org/confluence/display/FREESWITCH/Debian+8+Jessie
https://freeswitch.org/confluence/display/FREESWITCH/WebRTC#WebRTC-InstallCertificates

https://www.sslshopper.com/ssl-checker.html
