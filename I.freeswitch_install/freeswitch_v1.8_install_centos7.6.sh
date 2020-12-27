yum install -y http://files.freeswitch.org/freeswitch-release-1-6.noarch.rpm epel-release
yum install -y git alsa-lib-devel autoconf automake bison broadvoice-devel bzip2 curl-devel libdb4-devel e2fsprogs-devel erlang flite-devel g722_1-devel gcc-c++ gdbm-devel gnutls-devel ilbc2-devel ldns-devel libcodec2-devel libcurl-devel libedit-devel libidn-devel libjpeg-devel libmemcached-devel libogg-devel libsilk-devel libsndfile-devel libtheora-devel libtiff-devel libtool libuuid-devel libvorbis-devel libxml2-devel lua-devel lzo-devel mongo-c-driver-devel ncurses-devel net-snmp-devel openssl-devel opus-devel pcre-devel perl perl-ExtUtils-Embed pkgconfig portaudio-devel postgresql-devel python-devel python-devel soundtouch-devel speex-devel sqlite-devel unbound-devel unixODBC-devel wget which yasm zlib-devel libshout-devel libmpg123-devel lame-devel rpm-build libX11-devel libyuv-devel
cd /usr/local/src
git clone -b v1.8 https://gitee.com/dong2/freeswitch.git freeswitch

cd /usr/local/src/freeswitch
SWITCH_VERSION=$(cat build/next-release.txt); echo Building $SWITCH_VERSION; scripts/ci/src_tarball.sh; scripts/ci/get_extra_sources.sh; mv ../src_dist .; scripts/ci/rpmbuilder.sh $SWITCH_VERSION; echo Completed Build for FreeSWITCH $SWITCH_VERSION


https://freeswitch.org/confluence/display/FREESWITCH/CentOS+7+and+RHEL+7
