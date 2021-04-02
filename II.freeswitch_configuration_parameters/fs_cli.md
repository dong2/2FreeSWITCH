### 运维命令
```
在freeswitch/bin下使用fs_cil客户端。启动后在“freeswitch@internal>”控制器下进行操作，基本命令如下。
reloadxml    修改完xml后加载使用
sofia profile external rescan reloadxml 配置网关生效
sofia status   显示当前sofia状态
status         显示当前状态
sofia status profile internal reg 显示当前注册上来的用户信息
/quit          退出
```
http://www.simonzhang.net/?p=2239


### FreeSwitch常用命令
```
1.进入FS_cli:
    /usr/local/freeswitch/bin/fs_cli -H 127.0.0.1 -P 8021 -p password
2.停止FreeSwitch:
    /usr/local/freeswitch/bin/freeswitch -stop 
3.FS关闭日志:
    console loglevel 0
    sofia loglevel all 0
4.拨打分机命令:
    originate sofia/local/1001%127.0.0.1 &echo
5.查询网关状态:
    sofia status profile local 
6.查询网关分机注册状态:
    sofia status profile local reg
7.重启网关:
    sofia profile local restart
8.服务器时间同步:
    fsctl sync_clock
    fsctl sync_clock_when_idle
9.重启acl:
    reloadacl
10.开启/关闭SIP消息跟踪:
    sofia profile internal siptrace on
    sofia profile internal siptrace off
```
https://blog.csdn.net/nioqnw/article/details/84956819
