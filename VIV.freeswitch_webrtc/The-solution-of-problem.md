1. 通过FreeSWITCH，Linphone呼叫WebRTC的视频不通问题解决
https://my.oschina.net/andywang1988/blog/1186669

2. 使用WebRTC和WebVR进行VR视频通话
https://blog.csdn.net/vn9plgzvnps1522s82g/article/details/82392695

3. FreeSWITCH视频直播
http://www.freeswitch.org.cn/2017/03/27/freeswitch-live-2017.html

4. Freeswitch配置：一台Freeswitch向另外一台Freeswitch转发视频会议命令  
https://blog.csdn.net/quantum7/article/details/108671695

5. Verto Phone step-by-step
https://kovalyshyn.pp.ua/1249.html

6. nginx ssl config
```
# 一般情况不配置ssl_protocols，默认状态是
ssl_protocols SSLv3 TLSv1 TLSv1.1 TLSv1.2;

# 禁止SSLv3
ssl_protocols TLSv1 TLSv1.1 TLSv1.2;

# 没有禁止SSLv3,但是去掉了CBC算法
ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-RSA-RC4-SHA:AES128-GCM-SHA256:AES128-SHA256:AES128-SHA:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:AES256-GCM-SHA384:AES256-SHA256:AES256-SHA:ECDHE-RSA-AES128-SHA256:RC4-SHA:!aNULL:!eNULL:!EXPORT:!DES:!3DES:!MD5:!DSS:!PKS;
```
