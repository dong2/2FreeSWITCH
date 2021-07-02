```
1) Change password
vi /usr/local/freeswitch/conf/vars.xml
    Change:  <X-PRE-PROCESS cmd="set" data="default_password=1234"/> {!!set it to something different!!}
    Save and close (<Esc> :wq!)(默认密码会延时几秒才拨号)

2) Configuring SIP Port
vi /usr/local/freeswitch/conf/vars.xml
 <X-PRE-PROCESS cmd="set" data="internal_auth_calls=true"/>
  <X-PRE-PROCESS cmd="set" data="internal_sip_port=5060"/>
  <X-PRE-PROCESS cmd="set" data="internal_tls_port=5061"/>
  <X-PRE-PROCESS cmd="set" data="internal_ssl_enable=false"/>
 
  <!-- External SIP Profile -->
  <X-PRE-PROCESS cmd="set" data="external_auth_calls=false"/>
  <X-PRE-PROCESS cmd="set" data="external_sip_port=5080"/>
  <X-PRE-PROCESS cmd="set" data="external_tls_port=5081"/>
  <X-PRE-PROCESS cmd="set" data="external_ssl_enable=false"/>

3) Delete IPv6  (ipv4网络的话最好删掉ipv6配置)
cd /usr/local/freeswitch/conf/sip_profiles
mv internal-ipv6.xml internal-ipv6.xml.removed   {disables ipv6 support}
mv external-ipv6.xml external-ipv6.xml.removed   {disables ipv6 support}
mv external-ipv6 external-ipv6.removed           {disables ipv6 support}

4) Configuring ext-rtp-ip
vi conf/sip_profiles/internal.xml
    <param name="ext-rtp-ip" value="auto-nat"/>
    <param name="ext-sip-ip" value="auto-nat"/>

vi conf/sip_profiles/external.xml
    <param name="ext-rtp-ip" value="auto-nat"/>
    <param name="ext-sip-ip" value="auto-nat"/>

5) Configuring webrtc websocket
vi /usr/local/freeswitch/conf/sip_profiles/internal.xml
  <param name="ws-binding"  value=":5066"/>
  <param name="tls-cert-dir" value="/usr/local/freeswitch/certs"/>
  <param name="wss-binding" value=":7443"/>

6) Configuring loglevel
vi /usr/local/freeswitch/conf/vars.xml
  <!-- various debug and defaults -->
  <X-PRE-PROCESS cmd="set" data="call_debug=false"/>
  <X-PRE-PROCESS cmd="set" data="console_loglevel=info"/>
  <X-PRE-PROCESS cmd="set" data="default_areacode=918"/>
  <X-PRE-PROCESS cmd="set" data="default_country=US"/>

7) fs_cli.c:1673 main() Error Connecting []  (改成"0.0.0.0"就可以在本地连接fs_cli来调试,fs_cli默认端口是8021)
vi /usr/local/freeswitch/conf/autoload_configs/event_socket.conf.xml
　　<param name="listen-ip" value="::"/>  改为 <param name="listen-ip" value="0.0.0.0"/>

8) Configuring RTP port range
vi /usr/local/freeswitch/conf/autoload_configs/switch.conf.xml (默认端口16384~32768开得比较多)
<!-- RTP port range -->
<param name="rtp-start-port" value="16384"/>
<param name="rtp-end-port" value="32768"/>

9) Configuring ext-rtp-ip (verto不用可以不用管)
vi conf/autoload_configs/verto.conf.xml
    <param name="ext-rtp-ip" value=""/>

10) Startup freeswitch
cd /usr/local/freeswitch/bin
./freeswitch -nonat -nonatmap

.=============================================================.

|   _____              ______        _____ _____ ____ _   _   |
|  |  ___| __ ___  ___/ ___\ \      / /_ _|_   _/ ___| | | |  |
|  | |_ | '__/ _ \/ _ \___ \\ \ /\ / / | |  | || |   | |_| |  |
|  |  _|| | |  __/  __/___) |\ V  V /  | |  | || |___|  _  |  |
|  |_|  |_|  \___|\___|____/  \_/\_/  |___| |_| \____|_| |_|  |
|                                                             |
.=============================================================.
|   Anthony Minessale II, Michael Jerris, Brian West, Others  |
|   FreeSWITCH (http://www.freeswitch.org)                    |
|   Paypal Donations Appreciated: paypal@freeswitch.org       |
|   Brought to you by ClueCon http://www.cluecon.com/         |
.=============================================================.

.=======================================================================================================.
|    ____ _             ____                                                                            |
|   / ___| |_   _  ___ / ___|___  _ __                                                                  |
|  | |   | | | | |/ _ \ |   / _ \| '_ \                                                                 |
|  | |___| | |_| |  __/ |__| (_) | | | |                                                                |
|   \____|_|\__,_|\___|\____\___/|_| |_|                                                                |
|                                                                                                       |
|   _____    _            _                          ____             __                                |
|  |_   _|__| | ___ _ __ | |__   ___  _ __  _   _   / ___|___  _ __  / _| ___ _ __ ___ _ __   ___ ___   |
|    | |/ _ \ |/ _ \ '_ \| '_ \ / _ \| '_ \| | | | | |   / _ \| '_ \| |_ / _ \ '__/ _ \ '_ \ / __/ _ \  |
|    | |  __/ |  __/ |_) | | | | (_) | | | | |_| | | |__| (_) | | | |  _|  __/ | |  __/ | | | (_|  __/  |
|    |_|\___|_|\___| .__/|_| |_|\___/|_| |_|\__, |  \____\___/|_| |_|_|  \___|_|  \___|_| |_|\___\___|  |
|                  |_|                      |___/                                                       |
|   _____                           _                         _                                         |
|  | ____|_   _____ _ __ _   _     / \  _   _  __ _ _   _ ___| |_                                       |
|  |  _| \ \ / / _ \ '__| | | |   / _ \| | | |/ _` | | | / __| __|                                      |
|  | |___ \ V /  __/ |  | |_| |  / ___ \ |_| | (_| | |_| \__ \ |_                                       |
|  |_____| \_/ \___|_|   \__, | /_/   \_\__,_|\__, |\__,_|___/\__|                                      |
|                        |___/                |___/                                                     |
|                                       ____ _             ____                                         |
|  __      ____      ____      __      / ___| |_   _  ___ / ___|___  _ __         ___ ___  _ __ ___     |
|  \ \ /\ / /\ \ /\ / /\ \ /\ / /     | |   | | | | |/ _ \ |   / _ \| '_ \       / __/ _ \| '_ ` _ \    |
|   \ V  V /  \ V  V /  \ V  V /   _  | |___| | |_| |  __/ |__| (_) | | | |  _  | (_| (_) | | | | | |   |
|    \_/\_/    \_/\_/    \_/\_/   (_)  \____|_|\__,_|\___|\____\___/|_| |_| (_)  \___\___/|_| |_| |_|   |
|                                                                                                       |
.=======================================================================================================.
```　
