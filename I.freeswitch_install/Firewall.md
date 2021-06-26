centos  
[root@freeswitch ~]# systemctl stop firewalld.service
[root@freeswitch ~]# systemctl disable firewalld
[root@freeswitch ~]# sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux


debian  
[root@debian9]:apt-get install ufw  
[root@debian9]:ufw status
Status: inactive
[root@debian9]:/usr/src/freeswitch# ufw disable
Firewall stopped and disabled on system startup
