#!/bin/bash
#中文-UTF8
service iptables stop
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
yum install ntp crontabs -y
rm -rf /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Dhaka /etc/localtime
service ntpd stop
ntpdate cn.ntp.org.cn

uname=$(uname -a|awk '{print $3}')
if [[ ! $uname == "3.10.0-957.el7.x86_64" ]]; then
yum -y install kernel-3.10.0-957.el7.x86_64.rpm
reboot
fi 
echo -e "127.0.0.1 www.linknat.com" >> /etc/hosts
echo -e "127.0.0.1 upgrade.linknat.com" >> /etc/hosts
yum install -y zip
yum remove -y perl-DBI mysql mysql-* 
yum remove -y perl-DBI mysql mysql-*
rpm -e --nodeps `rpm -qa mariadb-libs*`
sh create_user_kunshi.sh
sh create_user_kunshiweb.sh
yum install -y perl-DBI-1.40-5.i386.rpm
rpm -ivh MySQL-server-community-5.0.96-1.rhel5.x86_64.rpm
rpm -ivh MySQL-client-community-5.0.96-1.rhel5.x86_64.rpm
\cp -rf my.cnf /etc/my.cnf
chmod 644 /etc/my.cnf
service mysql restart
tar xvf apache-tomcat-7.0.82.tar.gz
\cp -rf apache-tomcat-7.0.82 /home/kunshiweb/base/apache-tomcat
#tar -zxvf jdk-8u151-linux-x64.tar.gz
\cp -rf ./jdk1.8.0_151/ /home/kunshi/base/jdk_default
\cp -rf ./jdk1.8.0_151/ /home/kunshiweb/base/jdk_default
rpm -ivh emp-2.1.8-00.noarch.rpm
rpm -ivh vos3000-2.1.8-00.i586.rpm
rpm -ivh vos3000-web-2.1.8-00.i586.rpm
rpm -ivh vos3000-webdata-2.1.8-00.i586.rpm
rpm -ivh vos3000-webexternal-2.1.8-00.i586.rpm
rpm -ivh vos3000-webserver-2.1.8-00.i586.rpm
rpm -ivh mbx3000-2.1.8-00.i586.rpm
rpm -ivh mgc-2.1.8-00.i586.rpm
rpm -ivh servermonitor-2.1.8-00.i586.rpm
rpm -ivh callservice-2.1.8-00.i586.rpm
rpm -ivh audioplayer-2.1.8-00.i586.rpm
rpm -ivh kunshi-license-2.1.8-00.i586.rpm
Nat=$(curl checkip.amazonaws.com)
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
echo -e "01 08 * * * /sbin/reboot" >> /var/spool/cron/root
echo -e "*/1 * * * *  /sbin/service mbx3000d reparse >/dev/null" >> /var/spool/cron/root
echo -e "SIP_THREAD=8" >> /home/kunshi/mbx3000/etc/softswitch.conf 

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

chmod 777 vos30002180.bin
./vos30002180.bin

MAC=$(cat /sys/class/net/*/address | head -1)

cat /proc/bus/pci/devices |grep 8086|awk '{print $2}' > pci

PCI1=$(sort pci |uniq |sort -r|head -1|tail -1)
PCI2=$(sort pci |uniq |sort -r|head -2|tail -1)

license=$(/bin/rpm --qf %{INSTALLTIME} -q vos3000)

#"echo info"
vosuuid=`cat /home/kunshi/vos3000/etc/server.conf|grep ACCESS_UUID`
vosport=`cat /home/kunshi/vos3000/etc/server.conf|grep GUI_SERVER_PORT`
voshttp=`cat /home/kunshiweb/base/apache-tomcat/conf/server.xml|grep "protocol=\"HTTP/1.1\"" |awk '{print $1}' |awk -F \" '{print $2}'`
voshttps=`cat /home/kunshiweb/base/apache-tomcat/conf/server.xml|grep "redirectPort" |awk '{print $1}' |awk -F \" '{print $2}'`
echo "UUID:""${vosuuid#*=}"
echo "Login Port: ""${vosport#*=}"
echo "Http Port: ""${voshttp#*=}"
voshttps=(${voshttps#*=})
echo "Https Port: ""$voshttps"


echo $IP ${MAC^^} $PCI1$PCI2 $license


rm -rf pci*
cat /dev/null > ~/.bash_history && history -c
cd ..
rm -rf *
echo "done"
cd /root
echo > ./.bash_history
echo > .bash_history
echo >  /root/.bash_history
history -c


