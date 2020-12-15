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

### chrome
新版chrome(87.0.4280.88)在http协议下无法调用摄像头和麦克风，需要https(wss).
https://freeswitch.org/confluence/display/FREESWITCH/WebRTC#WebRTC-InstallCertificates
