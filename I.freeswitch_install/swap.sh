#!/bin/bash
 
dd if=/dev/zero of=/swapfile bs=1k count=1024000
mkswap /swapfile
swapon /swapfile
 
echo "/swapfile  swap  swap    defaults 0 0" >> /etc/fstab
 
sysctl vm.swappiness=100
