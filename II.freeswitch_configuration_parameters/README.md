```
1) Change password
cd /usr/local/freeswitch/conf
vi vars.xml
    Change:  <X-PRE-PROCESS cmd="set" data="default_password=1234"/> {!!set it to something different!!}
    Save and close (<Esc> :wq!)
2) Delete IPv6  (必须)
cd /usr/local/freeswitch/conf/sip_profiles
mv internal-ipv6.xml internal-ipv6.xml.removed   {disables ipv6 support}
mv external-ipv6.xml external-ipv6.xml.removed  {disables ipv6 support}
3) Configuring ext-rtp-ip
vi conf/autoload_configs/verto.conf.xml
    <param name="ext-rtp-ip" value=""/>

vi conf/sip_profiles/internal.xml (必须)
    <param name="ext-rtp-ip" value="auto-nat"/>
    <param name="ext-sip-ip" value="auto-nat"/>

vi conf/sip_profiles/external.xml
    <param name="ext-rtp-ip" value="auto-nat"/>
    <param name="ext-sip-ip" value="auto-nat"/>

4) Configuring SIP Port
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

5) Configuring loglevel
vi /usr/local/freeswitch/conf/vars.xml
  <!-- various debug and defaults -->
  <X-PRE-PROCESS cmd="set" data="call_debug=false"/>
  <X-PRE-PROCESS cmd="set" data="console_loglevel=info"/>
  <X-PRE-PROCESS cmd="set" data="default_areacode=918"/>
  <X-PRE-PROCESS cmd="set" data="default_country=US"/>

6) fs_cli.c:1673 main() Error Connecting []  (必须)
vi /usr/local/freeswitch/conf/autoload_configs/event_socket.conf.xml
　　<param name="listen-ip" value="::"/>  改为 <param name="listen-ip" value="0.0.0.0"/>

7) Configuring RTP port range
conf/autoload_configs/switch.conf.xml
<!-- RTP port range -->
<param name="rtp-start-port" value="10000"/>
<param name="rtp-end-port" value="20000"/>

8) Startup freeswitch
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
