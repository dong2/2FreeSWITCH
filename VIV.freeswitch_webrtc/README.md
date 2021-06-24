1. 首先关闭防火墙
```
systemctl stop firewalld.service
systemctl disable firewalld
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
```

2. 安装nginx
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

3. 安装coturn
```
sudo yum install coturn/sudo apt-get install coturn

# simple mode
turnserver -o -a -f -v --mobility -m 10 --max-bps=1024000 --min-port=16384 --max-port=32768 --user=test:test123 -r test --cert=/usr/local/nginx/conf/SSL_Pub.pem --pkey=/usr/local/nginx/conf/SSL_Priv.pem CA-file=/usr/local/nginx/conf/SSL_CA.pem
(开放端口与freeswitch/conf/autoload_configs/switch.conf.xml配置保持同步,允许通过的比特流速率1M=1024×1024不能太小, 可以不检测密钥)

或者直接编辑配置文件
listening-port=3478
verbose
fingerprint
lt-cred-mech
mobility
relay-threads=10
min-port=16384
max-port=32768
user=test:test123
realm=test

启动
turnserver -o -c /etc/turnserver.conf

# stop
ps aux | grep turnserver
found process id，example：2059
kill 2059
```

4. 生成openssl密钥
``` 
# Uncomment next line to create "privkey.pem" and "SSL_CA.pem" files
openssl req -days 3650 -out SSL_CA.pem -new -x509
# Save privkey.pem and SSL_CA.pem

# General Public and private files
openssl genrsa -out SSL_Priv.pem 1024
openssl req -key SSL_Priv.pem -new -out ./cert.req
echo 00 > file.srl
openssl x509 -req -days 3650 -in cert.req -CA SSL_CA.pem -CAkey privkey.pem -CAserial file.srl -out SSL_Pub.pem

# To convert to DER
#openssl x509 -outform der -in SSL_CA.pem -out SSL_CA.der
#openssl x509 -outform der -in SSL_Pub.pem -out SSL_Pub.der

# 我直接用了webrtc2sip项目自带的密钥,最好是自己生成.

# 转换成freeswitch格式的密钥
cat SSL_Pub.pem SSL_Priv.pem > /usr/local/freeswitch/certs/wss.pem
cat SSL_Pub.pem SSL_Priv.pem > /usr/local/freeswitch/certs/agent.pem
cat SSL_CA.pem > /usr/local/freeswitch/certs/cafile.pem
cat SSL_Pub.pem > /usr/local/freeswitch/certs/dtls-srtp.crt
# nginx密钥不用转换，直接拷贝过去就能用
cat SSL_Pub.pem > /usr/local/nginx/conf/SSL_Pub.pem
cat SSL_Priv.pem > /usr/local/nginx/conf/SSL_Priv.pem
cat SSL_CA.pem > /usr/local/nginx/conf/SSL_CA.pem

# freeswitch密钥格式跟nginx不一样，密钥生成和格式转换看  
https://gitee.com/dong2/webrtc2sip/blob/master/self-signed-certs.sh  
https://gitee.com/dong2/freeswitch/blob/master/docs/how_to_make_your_own_ca_correctly.txt  
https://github.com/coturn/coturn/tree/master/examples/etc  
https://www.cnblogs.com/fangpengchengbupter/p/7999704.html  
```

5. 配置freeswitch ssl  
```
1) Configuring webrtc websocket
vi /usr/local/freeswitch/conf/sip_profiles/internal.xml

  <param name="ws-binding"  value=":5066"/>
  <param name="tls-cert-dir" value="/usr/local/freeswitch/certs"/>
  <param name="wss-binding" value=":7443"/>
    
2) Configuring ext-rtp-ip
cd /usr/local/freeswitch/conf/sip_profiles/
vi internal.xml
    <param name="ext-rtp-ip" value="182.61.xx.25"/>
    <param name="ext-sip-ip" value="182.61.xx.25"/>

vi external.xml (新版本可能有stun信息)
    <param name="ext-rtp-ip" value="182.61.xx.25"/>
    <param name="ext-sip-ip" value="182.61.xx.25"/>

3）stun 
1.10.x版的stun在/usr/local/freeswitch/conf/vars.xml
  <X-PRE-PROCESS cmd="stun-set" data="external_rtp_ip=stun:182.61.xx.25:3478"/>
  <X-PRE-PROCESS cmd="stun-set" data="external_sip_ip=stun:182.61.xx.25:3478"/>  
  
```

6. 准备sipml5
```
cd /home
git clone https://gitee.com/dong2/sipml5.git
```

7. 分别启动nginx, coturn，freeswitch  
```
1) /usr/local/nginx/sbin/nginx -c /usr/local/nginx/conf/nginx.conf  
2) turnserver -o -c /etc/turnserver.conf
3) freeswitch -nonat -nonatmap -nosql  

重新配置freeswitch密钥需要删掉dtls-srtp.pem，启动会再次生成.
rm -rf /usr/local/freeswitch/certs/dtls-srtp.pem

此时，可以启动浏览器和linphone验证相关功能  
http://8.134.18.182/sipml5/call.htm  
https://8.134.18.182/sipml5/call.htm  
  
sipml5 ICE Servers:  
stunman [{url:'stun:8.134.18.182:3478'}]  
coturn [{url:'stun:8.134.18.182:3478'},{url:'turn:8.134.18.182:3478', username:'test', credential:'test123'}]  
有了turn也可以不要stun  
coturn [{url:'turn:8.134.18.182:3478', username:'test', credential:'test123'}]  

到目前为止freeswitch内置的webrtc已经支持
webrtc与webrtc之间的音视频互通和音视频会议模式，
sip设备与webrtc之间的音频互通和音频会议模式，
但是sip设备与webrtc之间的视频是单通，web可以收到linphone的视频，linphone收不到webrtc的视频，
zopier可以接入freeswtich webrtc视频会议，linphone接入是黑屏.

freeswtich可以不用内置的webrtc，可以另外配置webrtc2sip网关或者MCU来实现视频互通和视频会议,例如janus-gateway, licode, bigbluebutton等.  
我验证了janus-gateway，发现跟freeswitch内置的webrtc是一样的效果，仍然没有解决sip设备视频接入的问题,此问题留着慢慢调试,折腾freeswitch必然是个长期的事情.

freeswtich外置webrtc可以看看我的webrtc-list仓库，https://github.com/dong2/webrtc-list/blob/main/README.md
```

8. 注意：
```
Linphone on android 默认的设置里有个AVPF选项必须取消启动  
Linphone on windows 设置里的AVPF选项默认是未启动的  
fs, nginx, coturn 三个服务可以放在同一台服务器，或者或者不同的服务器, 但是密钥要配套, 我生成了一组10年期的密钥，放在conf目录.  
```
