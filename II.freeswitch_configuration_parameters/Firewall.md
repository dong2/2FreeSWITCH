[root@freeswitch ~]# systemctl stop firewalld.service
[root@freeswitch ~]# systemctl disable firewalld
[root@freeswitch ~]# sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
