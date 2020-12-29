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


# 补上mod_av模块
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

wget https://libav.org/releases/libav-12.3.tar.xz
tar xf libav-12.3.tar.xz
cd libav-12.3
# 进入 libav 源码目录下, 将 libavcodec/libx264.c 文件里面的 "x264_bit_depth" 全部替换为 "X264_BIT_DEPTH"，否则编译会报错。
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
# 然后像上面一样
./configure
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig
make
make -j install
make -j cd-sounds-install
make -j cd-moh-install

ln -sf /usr/local/freeswitch/bin/freeswitch /usr/bin/ 
ln -sf /usr/local/freeswitch/bin/fs_cli /usr/bin/

# 补上mod_signalwire，大多数情况不需要mod_signalwire，不要轻易添加mod_signalwire.

yum install libatomic -y

wget https://github.com/Kitware/CMake/releases/download/v3.15.2/cmake-3.15.2.tar.gz
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

# reference
https://freeswitch.org/confluence/display/FREESWITCH/CentOS+7+and+RHEL+7
https://blog.csdn.net/jiaojian8063868/article/details/110929209
https://zhuanlan.zhihu.com/p/153395654
