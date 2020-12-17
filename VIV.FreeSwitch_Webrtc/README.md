###  百问 FreeSwitch(第三版)
第 313 页  

### 1. freeswitch + webrtc
https://freeswitch.org/confluence/display/FREESWITCH/WebRTC

### 2. 公网sturn/trun + webrtc(sipml5)
vi conf/vars.xml
```
    <X-PRE-PROCESS cmd="stun-set" data="external_rtp_ip=stun:182.61.xx.25:3478"/>  
    <X-PRE-PROCESS cmd="stun-set" data="external_sip_ip=stun:182.61.xx.25:3478"/>  
```
vi conf/sip_profiles/internal.xml (必须)
```
    <param name="ext-rtp-ip" value="182.61.xx.25"/>
    <param name="ext-sip-ip" value="182.61.xx.25"/>
```
vi conf/sip_profiles/external.xml
```
    <param name="ext-rtp-ip" value="182.61.xx.25"/>
    <param name="ext-sip-ip" value="182.61.xx.25"/>
```

### 3. 内网sturn/trun + webrtc(sipml5)
bug list:

1. No candidate ACL defined Defaulting to wan auto
mod_sofia.c:2342 CODEC NEGOTIATION ERROR 
https://www.cnblogs.com/pangyangqi/p/10240351.html

2. How to Fix G729a CODEC NEGOTIATION ERROR in FreeSWITCH
https://howto.lintel.in/how-to-fix-g729a-codec-negotiation-error-in-freeswitch/


### Verto Phone step-by-step

https://kovalyshyn.pp.ua/1249.html
 

### firefox
sipml5 over ws 可以正常与linphone, zoiper通话

### chrome over wss
vi conf/sip_profiles/internal.xml
```
  <param name="tls-cert-dir" value="/usr/local/freeswitch/certs"/>
  <param name="wss-binding" value=":7443"/>
```
vi conf/vars.xml
```
  <!-- Internal SIP Profile -->
  <X-PRE-PROCESS cmd="set" data="internal_auth_calls=true"/>
  <X-PRE-PROCESS cmd="set" data="internal_sip_port=15060"/>
  <X-PRE-PROCESS cmd="set" data="internal_tls_port=15061"/>
  <X-PRE-PROCESS cmd="set" data="internal_ssl_enable=true"/>

  <!-- External SIP Profile -->
  <X-PRE-PROCESS cmd="set" data="external_auth_calls=true"/>
  <X-PRE-PROCESS cmd="set" data="external_sip_port=15080"/>
  <X-PRE-PROCESS cmd="set" data="external_tls_port=15081"/>
  <X-PRE-PROCESS cmd="set" data="external_ssl_enable=true"/>
```

###
https://freeswitch.org/confluence/display/FREESWITCH/SIP+TLS
https://freeswitch.org/confluence/display/FREESWITCH/Debian+8+Jessie
https://freeswitch.org/confluence/display/FREESWITCH/WebRTC#WebRTC-InstallCertificates
