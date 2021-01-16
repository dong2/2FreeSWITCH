1. 首先关闭防火墙
```
systemctl stop firewalld.service
systemctl disable firewalld
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
```

2. 配置freeswitch  
  
vi /usr/local/freeswitch/conf/vars.xml

```
  <X-PRE-PROCESS cmd="set" data="default_password=123456"/>

  <!-- Internal SIP Profile -->
  <X-PRE-PROCESS cmd="set" data="internal_auth_calls=true"/>
  <X-PRE-PROCESS cmd="set" data="internal_sip_port=15060"/>
  <X-PRE-PROCESS cmd="set" data="internal_tls_port=15061"/>
  <X-PRE-PROCESS cmd="set" data="internal_ssl_enable=true"/>

  <!-- External SIP Profile -->
  <X-PRE-PROCESS cmd="set" data="external_auth_calls=false"/>
  <X-PRE-PROCESS cmd="set" data="external_sip_port=15080"/>
  <X-PRE-PROCESS cmd="set" data="external_tls_port=15081"/>
  <X-PRE-PROCESS cmd="set" data="external_ssl_enable=true"/>
```
  
vi /usr/local/freeswitch/conf/sip_profiles/internal.xml
```
  <param name="ws-binding"  value=":5066"/>
  <param name="tls-cert-dir" value="/usr/local/freeswitch/certs"/>
  <param name="wss-binding" value=":7443"/>
```
  
mv internal-ipv6.xml internal-ipv6.xml.removed  
mv external-ipv6.xml external-ipv6.xml.removed  
mv external-ipv6 external-ipv6.removed
  
vi /usr/local/freeswitch/conf/autoload_configs/event_socket.conf.xml
```
  <param name="listen-ip" value="0.0.0.0"/>
```
  
vi /usr/local/freeswitch/conf/autoload_configs/switch.conf.xml (默认端口16384~32768开得比较多)
```
  <!-- RTP port range -->
  <param name="rtp-start-port" value="16384"/> 
  <param name="rtp-end-port" value="32768"/> 
```
  
vi /usr/local/freeswitch/conf/directory/default.xml
```
<param name="dial-string" value="{^^:sip_invite_domain=${dialed_domain}:presence_id=${dialed_user}@${dialed_domain}}${sofia_contact(*/${dialed_user}@${dialed_domain})},${verto_contact(${dialed_user}@${dialed_domain})}"/>

# delete ",${verto_contact(${dialed_user}@${dialed_domain})}"
```
3. 拷贝freeswitch密钥
```
scp -r freeswitch-v1.10.5/certs root@8.134.56.226:/usr/local/freeswitch
# freeswitch密钥格式跟nginx不一样，密钥生成和格式转换看  
https://gitee.com/dong2/webrtc2sip/blob/master/self-signed-certs.sh  
https://gitee.com/dong2/freeswitch/blob/master/docs/how_to_make_your_own_ca_correctly.txt  
```
4. 准备sipml5
```
cd /home
git clone https://gitee.com/dong2/sipml5.git
```

5. 启动freeswitch  
freeswitch -nonat -nonatmap -nosql  

此时，可以启动浏览器和linphone验证相关功能  
http://8.134.18.182/sipml5/call.htm  
https://8.134.18.182/sipml5/call.htm  
  
sipml5 ICE Servers:  
stunman [{url:'stun:8.134.18.182:3478'}]  
coturn [{url:'stun:8.134.18.182:3478'},{url:'turn:8.134.18.182:3478', username:'test', credential:'test123'}]  

到目前为止freeswitch的webrtc模块还不能接入sip终端的视频(音频可以接入)，需要另外配置webrtc2sip网关或者MCU来实现,例如janux-gateway, bigbluebutton, licode等.  
freeswitch需要配置成bypass模式，参考：https://blog.csdn.net/wanglf1986/article/details/52162614  

# 4. 生成openssl密钥
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
```

# 5. 注意：  
Linphone on android 默认的设置里有个AVPF选项必须取消启动  
Linphone on windows 设置里的AVPF选项默认是未启动的  

