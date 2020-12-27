# easy way
yum install -y https://files.freeswitch.org/repo/yum/centos-release/freeswitch-release-repo-0-1.noarch.rpm epel-release
yum install -y freeswitch-config-vanilla freeswitch-lang-* #freeswitch-sounds-*
systemctl enable freeswitc


# source install
yum install vim git wget lrzsz
yum install autoconf automake libtool openssl* libtiff* libjpeg*

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

cd /usr/local/src
git clone -b v1.10.5 https://gitee.com/dong2/freeswitch.git freeswitch
cd freeswitch
./bootstrap.sh -j
此时可以编辑配置需要编译的freeswitch模块，可以关闭不需要使用的模块。此处我注释掉了mod_av和mod_signalwire
vi modules.conf
./configure
此处如果遇到"no usable spandsp"异常时，按照官方指示设置下环境变量，之后重新configure
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig
make
make -j install
make -j cd-sounds-install
make -j cd-moh-install

# reference
https://freeswitch.org/confluence/display/FREESWITCH/CentOS+7+and+RHEL+7
https://blog.csdn.net/jiaojian8063868/article/details/110929209
