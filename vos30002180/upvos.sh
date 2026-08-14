#!/bin/bash
#中文-UTF8
service iptables stop
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
yum install ntp crontabs -y
rm -rf /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
service ntpd stop
ntpdate cn.ntp.org.cn
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
yum install -y zip
tar xvf apache-tomcat-7.0.82.tar.gz
\cp -rf apache-tomcat-7.0.82 /home/kunshiweb/base/apache-tomcat
tar -zxvf jdk-8u151-linux-x64.tar.gz
\cp -rf ./jdk1.8.0_151/ /home/kunshi/base/jdk_default
\cp -rf ./jdk1.8.0_151/ /home/kunshiweb/base/jdk_default
rpm -Uvh emp-2.1.8-00.noarch.rpm
rpm -Uvh vos3000-2.1.8-00.i586.rpm
rpm -Uvh vos3000-web-2.1.8-00.i586.rpm
rpm -Uvh vos3000-webdata-2.1.8-00.i586.rpm
rpm -Uvh vos3000-webexternal-2.1.8-00.i586.rpm
rpm -Uvh vos3000-webserver-2.1.8-00.i586.rpm
rpm -Uvh mbx3000-2.1.8-00.i586.rpm
rpm -Uvh mgc-2.1.8-00.i586.rpm
rpm -Uvh servermonitor-2.1.8-00.i586.rpm
rpm -Uvh callservice-2.1.8-00.i586.rpm
rpm -Uvh audioplayer-2.1.8-00.i586.rpm
rpm -Uvh kunshi-license-2.1.8-00.i586.rpm
Nat=$(curl 111.231.196.232/ip.php)
HOSTIP=$(ip a|grep -o -e 'inet [0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}'|grep -v "127"|awk '{print $2}')
echo -e "$HOSTIP" >> hostip
tar xvf mediarecord.tar.gz -C / >/dev/null 2>/dev/null
IP=$(head -2 hostip | tail -1)
if  [[ "$IP" == "$Nat" ]];then
	sed -i -e 's/192.168.0.166/'$IP'/g' /home/kunshi/mediarecord/etc/mediarecord.conf
fi
IP=$(head -1 hostip | tail -1)
sed -i -e 's/192.168.0.166/'$IP'/g' /home/kunshi/mediarecord/etc/mediarecord.conf
chkconfig mediarecordd on
chkconfig ntpd on
chkconfig sendmail off
chown -R kunshiweb.kunshiweb /home/kunshiweb
chown -R kunshi.kunshi /home/kunshi
./vos300021800.bin
ip add
uuid=$(head -2 /home/kunshi/vos3000/etc/server.conf | tail -1)
vos=$(head -23 /home/kunshi/vos3000/etc/server.conf | tail -1)
web=$(head -61 /home/kunshiweb/base/apache-tomcat/conf/server.xml | tail -1)
#phone=$(head -64 /home/kunshiweb/base/apache-tomcat/conf/server.xml | tail -1)
echo "系统标识" ${uuid#*ACCESS_UUID=}
echo "登录端口" ${vos#*GUI_SERVER_PORT=}
echo "查费端口" ${web#*port=}
#echo "手机端口" ${phone#*redirectPort=}
cd ..
rm -rf *
echo "done"
cd /root
echo > ./.bash_history
echo > .bash_history
echo >  /root/.bash_history
history -c


