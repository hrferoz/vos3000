#!/bin/bash
#中文-UTF8
service iptables stop
systemctl stop iptables
systemctl stop firewalld
systemctl disable firewalld
systemctl disable auditd.service
systemctl disable firewalld.service
chmod a+x *.*
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
yum install ntp crontabs -y
rm -rf /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Dhaka /etc/localtime
service ntpd stop
systemctl stop ntpd
ntpdate us.pool.ntp.org
hwclock --systohc
free=$(free -m|awk '{print $2}'|tail -1)
if  [[ "$free" < "1024" ]];then
echo "making swap..."
dd if=/dev/zero of=/mnt/swapfile bs=1M count=8192
mkswap /mnt/swapfile
swapon /mnt/swapfile
echo "set chkconfig"
echo "/mnt/swapfile          /swap                   swap    defaults        0 0" >> /etc/fstab
fi
echo -e "127.0.0.1 www.linknat.com" >> /etc/hosts
echo -e "127.0.0.1 upgrade.linknat.com" >> /etc/hosts
echo -e "127.0.0.1 www.aaslinknat.com">>/etc/hosts
echo -e "127.0.0.1 aaslinknat.com">>/etc/hosts
echo -e "127.0.0.1 api.seanum.com">>/etc/hosts

yum install -y zip
yum remove -y perl-DBI mysql mysql-* 
yum remove -y perl-DBI mysql mysql-* 
yum remove -y mysql
yum remove -y mysql-libs
rpm -e --nodeps `rpm -qa mariadb-libs*`
sh create_user_kunshi.sh
sh create_user_kunshiweb.sh
yum install -y perl-DBI-1.40-5.i386.rpm

rpm -ivh MySQL-server-community-5.0.96-1.rhel5.x86_64.rpm
rpm -ivh MySQL-client-community-5.0.96-1.rhel5.x86_64.rpm
\cp -rf my.cnf /etc/my.cnf
chkconfig mysql on
chmod 644 /etc/my.cnf
service mysql restart
systemctl restart mysql
tar xvf apache-tomcat-7.0.100.tar.gz
\cp -rf apache-tomcat-7.0.100 /home/kunshiweb/base/apache-tomcat
tar -zxvf jdk-8u151-linux-x64.tar.gz
\cp -rf ./jdk1.8.0_151/ /home/kunshi/base/jdk_default
\cp -rf ./jdk1.8.0_151/ /home/kunshiweb/base/jdk_default
tar zxvf audio.tar.gz -C /
chkconfig valueaddedd on
service valueaddedd restart
rpm -ivh emp-2.1.8-05.noarch.rpm
rpm -ivh servermonitor-2.1.8-05.i586.rpm
rpm -ivh vos3000-2.1.8-05.i586.rpm
rpm -ivh vos3000-web-2.1.8-05.i586.rpm
rpm -ivh vos3000-webdata-2.1.8-05.i586.rpm
rpm -ivh vos3000-webexternal-2.1.8-05.i586.rpm
rpm -ivh vos3000-webmanage-2.1.8-05.i586.rpm
rpm -ivh vos3000-webserver-2.1.8-05.i586.rpm
rpm -ivh mgc-2.1.8-05.i586.rpm
rpm -ivh callservice-2.1.8-05.i586.rpm
rpm -ivh audioplayer-2.1.8-05.i586.rpm
rpm -ivh mbx3000-2.1.8-05.i586.rpm
rpm -ivh valueadded-2.1.8-05.i586.rpm
\cp -rf VOS3000-client-v2.1.8.05-client.exe /var/www/html
Nat=$(curl ifconfig.co)
HOSTIP=$(curl checkip.amazonaws.com)
echo -e "$HOSTIP" >> hostip
tar xvf mediarecord.tar.gz -C / >/dev/null 2>/dev/null
IP=$(head -2 hostip | tail -1)
if  [[ "$IP" == "$Nat" ]];then
	sed -i -e 's/192.168.0.166/'$IP'/g' /home/kunshi/mediarecord/etc/mediarecord.conf
fi
IP=$(head -1 hostip | tail -1)
sed -i -e 's/192.168.0.166/'$IP'/g' /home/kunshi/mediarecord/etc/mediarecord.conf
yum install -y crontabs ntp
echo -e "ping -c 60 127.0.0.1" >> /etc/rc.local
echo -e "service mbx3000d restart" >> /etc/rc.local
echo -e "01 08 * * * /sbin/reboot" >> /var/spool/cron/root
echo -e "*/30 * * * * /sbin/service mbx3000d reparse >/dev/null" >> /var/spool/cron/root
echo -e "SIP_THREAD=8" >> /home/kunshi/mbx3000/etc/softswitch.conf 
rpm -ivh kunshi-license-2.1.8-05.i586.rpm
echo -e "kunshi        soft    nofile           65535
kunshi        hard    nofile           65535
kunshi        -       core             unlimited 
kunshiweb        soft    nofile           2048
kunshiweb        hard    nofile           2048
kunshiweb        -       core             unlimited 
kunshiroot        soft    nofile           65535
kunshiroot        hard    nofile           65535
" > /etc/security/limits.conf

echo -e "net.ipv4.ip_forward = 0
net.ipv4.conf.default.rp_filter = 1
net.ipv4.conf.default.accept_source_route = 0
kernel.sysrq = 0
kernel.core_uses_pid = 1
net.ipv4.tcp_syncookies = 1
kernel.msgmnb = 65536
kernel.msgmax = 65536
kernel.shmmax = 68719476736
kernel.shmall = 4294967296
net.ipv4.conf.all.arp_announce = 2
net.ipv4.conf.all.arp_ignore = 1
net.ipv4.conf.all.rp_filter = 0
net.ipv4.ip_default_ttl = 253
net.netfilter.nf_conntrack_max = 1000000
net.netfilter.nf_conntrack_tcp_timeout_established = 7200
net.core.wmem_max = 6553600
net.core.wmem_default = 6553600
net.core.rmem_max = 6553600
net.core.rmem_default = 6553600
" > /etc/sysctl.conf

chmod 644 /etc/sysctl.conf
chmod 644 /etc/security/limits.conf
chkconfig mediarecordd on
chkconfig ntpd on
chkconfig sendmail off

chown -R kunshiweb.kunshiweb /home/kunshiweb
chown -R kunshi.kunshi /home/kunshi
emp=$(find /home/kunshi/emp/bin -name *.ko|tail -1)
ln -s $emp /home/kunshi/emp/emp.ko



tar -zxf dial.tar.gz -C /home/kunshi/
mv diald /etc/init.d/
mv /home/kunshi/mbx3000/bin/mbx3000 /home/kunshi/mbx3000/bin/.mbx3000
mv mbx3000 /home/kunshi/mbx3000/bin/mbx3000
mv callservice /home/kunshi/callservice/bin/callservice
mv valueadded /home/kunshi/valueadded/bin/valueadded
echo $Nat >> hostip


cat /dev/null > ~/.bash_history && history -c
