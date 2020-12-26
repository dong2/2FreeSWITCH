### FreeSwitch_Webrtc2sip_Gateway

sudo yum update  

sudo yum install make libtool autoconf subversion git cvs wget libogg-devel gcc gcc-c++ pkgconfig  

```
1. yasm
wget http://www.tortall.net/projects/yasm/releases/yasm-1.2.0.tar.gz
tar -xvzf yasm-1.2.0.tar.gz
cd yasm-1.2.0
./configure --enable-shared
make
make install

2. nasm
wget https://www.nasm.us/pub/nasm/releasebuilds/2.13.03/nasm-2.13.03.tar.gz
./configure
make
make install
 
3. libsrtp
git clone https://gitee.com/dong2/libsrtp.git
cd libsrtp
git checkout v1.5.2
CFLAGS="-fPIC" ./configure --enable-pic
make
make install

4. openssl
wget http://www.openssl.org/source/openssl-1.0.1c.tar.gz
tar -xvzf openssl-1.0.1c.tar.gz
cd openssl-1.0.1c
./config shared --prefix=/usr/local --openssldir=/usr/local/openssl
make
make install
ln -s /usr/local/lib64/libssl.so.1.0.0 /usr/lib64/libssl.so.1.0.0
ln -s /usr/local/lib64/libcrypto.so.1.0.0 /usr/lib64/libcrypto.so.1.0.0

5. speex
wget http://downloads.xiph.org/releases/speex/speex-1.2beta3.tar.gz
tar -xvzf speex-1.2beta3.tar.gz
cd speex-1.2beta3
./configure --disable-oggtest --without-libogg
make
make install

6. libvpx
sudo yum install libvpx-devel
if 0
git clone https://gitee.com/dong2/libvpx.git
cd libvpx
./configure --enable-realtime-only --enable-error-concealment --disable-examples --enable-vp8 --enable-pic --enable-shared --as=yasm
make
make install
endif

7. libyuv
git clone https://gitee.com/dong2/libyuv.git
mkdir out
cd out
cmake -DCMAKE_INSTALL_PREFIX="/usr/local" -DCMAKE_BUILD_TYPE="Release" ..
cmake --build . --config Release
cmake --build . --target install --config Release
cp ./include/libyuv.h /usr/local/include/libyuv/

# uninstall:
# cat install_manifest.txt | sudo xargs rm

8. opencore-amr
//wget https://sourceforge.net/projects/opencore-amr/files/opencore-amr/opencore-amr-0.1.5.tar.gz/download
git clone git://opencore-amr.git.sourceforge.net/gitroot/opencore-amr/opencore-amr
autoreconf --install
./configure
make
make install

9. opus
wget http://downloads.xiph.org/releases/opus/opus-1.0.2.tar.gz
tar -xvzf opus-1.0.2.tar.gz
cd opus-1.0.2
./configure --with-pic --enable-float-approx
make
make install

10. gsm
wget http://www.quut.com/gsm/gsm-1.0.13.tar.gz
tar -xvzf gsm-1.0.13.tar.gz
cd gsm-1.0-pl13
# must add Makefile -fPIC
make
make install
cp -rf ./inc/* /usr/local/include
cp -rf ./lib/* /usr/local/lib

11. g729b
git clone https://gitee.com/dong2/g729b.git
cd g729b
./autogen.sh
./configure --enable-static --disable-shared
make
make install

12. ilbc 
git clone https://gitee.com/dong2/ilbc.git
cd ilbc
wget http://www.ietf.org/rfc/rfc3951.txt
awk -f extract.awk rfc3951.txt
./autogen.sh
./configure
make
make install

13. x264
git clone https://gitee.com/dong2/x264.git
# the output directory may be difference depending on the version and date
cd x264
./configure --enable-shared --enable-pic
make
make install

14. ffmpeg
git https://gitee.com/dong2/ffmpeg.git ffmpeg
cd ffmpeg
# grap a release branch
git checkout n1.2
# configure source code
./configure --extra-cflags="-fPIC" --extra-ldflags="-lpthread" --enable-pic --enable-memalign-hack --enable-pthreads --enable-shared --disable-static --disable-network --enable-pthreads --disable-ffmpeg --disable-ffplay --disable-ffserver --disable-ffprobe --enable-gpl --disable-debug
make
make install

15. doubango
git clone https://gitee.com/dong2/doubango.git doubango
cd doubango
# vi tinySAK/src/tsk_common.h
typedef uint8_t   uint8;
typedef uint32_t  uint32;

./autogen.sh
./configure --with-ssl --with-srtp --with-vpx --with-yuv --with-amr --with-speex --with-speexdsp --with-gsm --with-ilbc --with-g729b --with-ffmpeg
make
make install

16. webrtc2sip
yum install libxml2-devel
export PREFIX=/opt/webrtc2sip
cd webrtc2sip
./autogen.sh
./configure --prefix=$PREFIX
make clean
# vi Makefile
webrtc2sip_LDADD = \
-L${LIBXML2_LIB} \
-L${LIBPTHREAD_LIB} \
${DOUBANGO_LIBS_FALLBACK} \
${TINYSAK_LIBS} \
...
-lxml2 \
-lpthread \
-ldl

make
make install
cp -f ./config.xml $PREFIX/sbin/config.xml
```

# reference
1. https://github.com/DoubangoTelecom/webrtc2sip/blob/master/documentation/technical-guide-1.0.pdf
2. https://github.com/DoubangoTelecom/doubango/blob/master/Building_Source_v2_0.md





