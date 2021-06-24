1. 安装依赖库
```
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
# 或者参考官网https://freeswitch.org/confluence/display/FREESWITCH/CentOS+7+and+RHEL+7
```

2. 补上mod_av模块
```
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
# scp patch/libx264.c root@8.134.56.226:/usr/local/src/libav-12.3/libavcodec/
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
```

3. 补上mod_signalwire，大多数情况不需要mod_signalwire.
```
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
```

4. 最后安装freeswitch
```
git clone -b v1.10.5 https://gitee.com/dong2/freeswitch.git freeswitch
cd freeswitch
# freeswitch v1.10.5 默认配置就可以支持语音会议，视频会议，但是fs对与sip终端的处理需要调整
# scp patch/switch_rtp.c root@8.134.56.226:/usr/local/src/freeswitch/src
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

