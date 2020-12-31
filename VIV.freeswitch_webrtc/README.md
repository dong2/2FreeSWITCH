# 1. freeswitch快速安装，这在方式很多外设模块都没有
```
yum install -y https://files.freeswitch.org/repo/yum/centos-release/freeswitch-release-repo-0-1.noarch.rpm epel-release
yum install -y freeswitch-config-vanilla freeswitch-lang-* #freeswitch-sounds-*
systemctl enable freeswitc
```

# 2. freeswitch源码安装，可以自定义外设模块
```
1. 安装依赖库
yum install vim git wget lrzsz
yum install autoconf automake libtool openssl* libtiff* libjpeg*

cd /usr/local/src
git clone https://gitee.com/dong2/sofia-sip
cd sofia-sip
./bootstrap.sh
./configure
make
make install

git clone https://gitee.com/dong2/spandsp
cd spandsp
./bootstrap.sh
./configure
make
make install

export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig

yum install -y https://files.freeswitch.org/repo/yum/centos-release/freeswitch-release-repo-0-1.noarch.rpm epel-release
yum install yum-utils
yum-builddep -y freeswitch --skip-broken
yum install -y yum-plugin-ovl centos-release-scl rpmdevtools

# 此时如果不需要视频模块直接跳到第4步安装freeswitch即可

2. 补上mod_av模块
wget https://www.nasm.us/pub/nasm/releasebuilds/2.14.02/nasm-2.14.02.tar.xz
tar xf nasm-2.14.02.tar.xz
cd nasm-2.14.02
./configure
make
make install

git clone https://gitee.com/dong2/x264.git
# the output directory may be difference depending on the version and date
cd x264
./configure --enable-shared --enable-pic
make
make install

git clone https://gitee.com/dong2/libpng.git
cd libpng
./configure
make
make install
cp /usr/local/lib/pkgconfig/libpng* /usr/lib64/pkgconfig/

wget https://libav.org/releases/libav-12.3.tar.xz
tar xf libav-12.3.tar.xz
cd libav-12.3
# 进入 libav 源码目录下, 将 libavcodec/libx264.c 文件里面的 "x264_bit_depth" 全部替换为 "X264_BIT_DEPTH"，否则编译会报错。
# scp libx264.c root@8.134.56.226:/usr/local/src/libav-12.3/libavcodec/
./configure --enable-shared --enable-libx264 --enable-gpl
make
make install
ln -sf /usr/local/lib/pkgconfig/libavcodec.pc  /usr/lib64/pkgconfig/libavcodec.pc
ln -sf /usr/local/lib/pkgconfig/libavdevice.pc  /usr/lib64/pkgconfig/libavdevice.pc
ln -sf /usr/local/lib/pkgconfig/libavfilter.pc  /usr/lib64/pkgconfig/libavfilter.pc
ln -sf /usr/local/lib/pkgconfig/libavformat.pc  /usr/lib64/pkgconfig/libavformat.pc
ln -sf /usr/local/lib/pkgconfig/libavresample.pc  /usr/lib64/pkgconfig/libavresample.pc
ln -sf /usr/local/lib/pkgconfig/libavutil.pc  /usr/lib64/pkgconfig/libavutil.pc
ln -sf /usr/local/lib/pkgconfig/libswscale.pc  /usr/lib64/pkgconfig/libswscale.pc

ldconfig

3. 补上mod_signalwire，大多数情况不需要mod_signalwire，不要轻易添加mod_signalwire.

yum install libatomic -y

wget http://www.cmake.org/files/v3.15/cmake-3.15.2.tar.gz
tar xf cmake-3.15.2.tar.gz
cd cmake-3.15.2
./bootstrap 
gmake
make install

git clone https://github.com/signalwire/libks.git
cd libks
cmake .
make
make install

git clone https://github.com/signalwire/signalwire-c.git
cd signalwire-c
cmake .
make
make install

4. 最后安装freeswitch
git clone -b v1.10.5 https://gitee.com/dong2/freeswitch.git freeswitch
cd freeswitch
# freeswitch v1.10.5 默认配置就可以支持语音会议，视频会议，但是fs对与sip终端的处理需要调整
# scp switch_rtp.c root@8.134.56.226:/usr/local/src/freeswitch/src
./bootstrap.sh -j
# 屏蔽 signalwire
# vi modules.conf
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig
./configure
make
make -j install

# 手动上传音频文件，节约时间
scp freeswitch-sounds-* root@8.134.56.226:/usr/local/src/freeswitch

make -j cd-sounds-install
make -j cd-moh-install

ln -sf /usr/local/freeswitch/bin/freeswitch /usr/bin/ 
ln -sf /usr/local/freeswitch/bin/fs_cli /usr/bin/
```

# 3. 最简单配置

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

vi /usr/local/freeswitch/conf/autoload_configs/event_socket.conf.xml
```
  <param name="listen-ip" value="0.0.0.0"/>
```

vi /usr/local/freeswitch/conf/autoload_configs/switch.conf.xml (默认端口开得比较多)
```
  <!-- RTP port range -->
  <param name="rtp-start-port" value="10000"/> 
  <param name="rtp-end-port" value="10050"/> 
```

vi /usr/local/freeswitch/conf/directory/default.xml
```
<param name="dial-string" value="{^^:sip_invite_domain=${dialed_domain}:presence_id=${dialed_user}@${dialed_domain}}${sofia_contact(*/${dialed_user}@${dialed_domain})},${verto_contact(${dialed_user}@${dialed_domain})}"/>

# delete ",${verto_contact(${dialed_user}@${dialed_domain})}"
```
3. 拷贝freeswitch密钥
```
scp -r freeswitch-v1.10.5/certs root@8.134.56.226:/usr/local/freeswitch
# freeswitch密钥格式跟nginx不一样，密钥生成和格式转换看VIV.freeswitch_webrtc/ssl.doc/README.md
```

4. 安装nginx
```
yum install gcc-c++ pcre pcre-devel zlib zlib-devel #openssl openssl-devel
wget https://nginx.org/download/nginx-1.14.0.tar.gz
tar zxf nginx-1.14.0.tar.gz
cd nginx-1.14.0
./configure --prefix=/usr/local/nginx --with-http_stub_status_module --with-http_ssl_module
make
make install

# 拷贝nginx密钥和配置文件
scp nginx-1.14.0/nginx.conf root@8.134.56.226:/usr/local/nginx/conf
scp ssl/SSL* root@8.134.56.226:/usr/local/nginx/conf

# 启动nginx
/usr/local/nginx/sbin/nginx -s quit
/usr/local/nginx/sbin/nginx -c /usr/local/nginx/conf/nginx.conf
/usr/local/nginx/sbin/nginx -s reload
```

6. 安装coturn
```
# 直接在线安装
yum install coturn
# 启动coturn
turnserver -o -a -f -v --mobility -m 10 --max-bps=1024000 --min-port=10000 --max-port=10050 --user=test:test123 -r test
(开放端口与freeswitch配置保持同步)
```

6. 准备sipml5
```
cd /home
git clone https://gitee.com/dong2/sipml5.git
mv sipml5 sip
```

7. 启动freeswitch
freeswitch -nonat -nonatmap -nosql  

此时，可以启动浏览器和linphone验证相关功能  
http://8.134.56.226/sip/call.htm  
https://8.134.56.226/sip/call.htm  


# 4. 生成openssl密钥
```
# https://gitee.com/dong2/webrtc2sip/blob/master/self-signed-certs.sh  
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
```

# 5. 注意：  
Linphone on android 默认的设置里有个AVPF选项必须取消启动  
Linphone on windows 设置里的AVPF选项默认是未启动的  

# 6. reference
https://freeswitch.org/confluence/display/FREESWITCH/CentOS+7+and+RHEL+7  
https://blog.csdn.net/jiaojian8063868/article/details/110929209  
https://zhuanlan.zhihu.com/p/153395654  
