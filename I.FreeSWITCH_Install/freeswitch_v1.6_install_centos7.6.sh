#
yum install -y http://files.freeswitch.org/freeswitch-release-1-6.noarch.rpm epel-release

yum install -y git alsa-lib-devel autoconf automake bison broadvoice-devel bzip2 curl-devel db-devel e2fsprogs-devel flite-devel g722_1-devel gcc-c++ gdbm-devel gnutls-devel ilbc2-devel ldns-devel libcodec2-devel libcurl-devel libedit-devel libidn-devel libjpeg-devel libmemcached-devel libogg-devel libsilk-devel libsndfile-devel libtheora-devel libtiff-devel libtool libuuid-devel libvorbis-devel libxml2-devel lua-devel lzo-devel mongo-c-driver-devel ncurses-devel net-snmp-devel openssl-devel opus-devel pcre-devel perl perl-ExtUtils-Embed pkgconfig portaudio-devel postgresql-devel python26-devel python-devel soundtouch-devel speex-devel sqlite-devel unbound-devel unixODBC-devel wget which yasm zlib-devel

#
cd /usr/local/src
#git clone -b v1.6 https://github.com/signalwire/freeswitch.git freeswitch
git clone -b v1.6 https://gitee.com/cnwz/freeswitch.git freeswitch
cd /usr/local/src/freeswitch
./bootstrap.sh -j
./configure
make -j
make -j install

#
#make -j cd-sounds-install
#make -j cd-moh-install

#
ln -sf /usr/local/freeswitch/bin/freeswitch /usr/bin/ 
ln -sf /usr/local/freeswitch/bin/fs_cli /usr/bin/

# 
#freeswitch
#freeswitch -nc
#freeswitch -nonat -nonatmap -nosql

#
#netstat -anp|grep 5060

#
#fs_cli
