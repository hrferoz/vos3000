setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
chmod 777 *
yum remove -y perl perl-DBI mysql mysql-* 
yum remove -y perl perl-DBI mysql mysql-* 
sh create_user_kunshi.sh
sh create_user_kunshiweb.sh
yum install -y perl-DBI-1.40-5.i386.rpm -y
rpm -ivh MySQL-server-community-5.0.96-1.rhel5.x86_64.rpm
rpm -ivh MySQL-client-community-5.0.96-1.rhel5.x86_64.rpm
service mysql restart
chkconfig mysql on
\cp -rf my.cnf /etc/my.cnf
chmod 644 /etc/my.cnf
service mysql restart
rpm -ivh jdk-6u45-linux-amd64.rpm
#tar zxvf apache-tomcat-7.0.23.tar.gz
mv apache-tomcat-7.0.23 /home/kunshiweb/base/apache-tomcat
tar -zxvf jrockit-jdk1.6.0_33-R28.2.4-4.1.0.tar.gz
\cp -rf ./jrockit-jdk1.6.0_33-R28.2.4-4.1.0/ /home/kunshi/base/jdk_default
\cp -rf ./jrockit-jdk1.6.0_33-R28.2.4-4.1.0/ /home/kunshiweb/base/jdk_default
rpm -ivh emp-2.1.6-00.noarch.rpm
rpm -ivh vos3000-2.1.6-00.i586.rpm
rpm -ivh vos3000-web-2.1.6-00.i586.rpm
rpm -ivh vos3000-webdata-2.1.6-00.i586.rpm
rpm -ivh vos3000-webexternal-2.1.6-00.i586.rpm
rpm -ivh vos3000-webthirdparty-2.1.6-00.i586.rpm
rpm -ivh vos3000-webserver-2.1.6-00.i586.rpm
rpm -ivh mbx3000-2.1.6-00.i586.rpm
rpm -ivh mgc-2.1.6-00.i586.rpm
rpm -ivh servermonitor-2.1.6-00.i586.rpm
rpm -ivh callservice-2.1.6-00.i586.rpm
rpm -ivh dial-2.1.6-00.i586.rpm
rpm -ivh valueadded-2.1.6-00.i586.rpm
cp -rp /usr/share/zoneinfo/Asia/Dhaka /etc/localtime
ln -sf /usr/share/zoneinfo/Asia/Dhaka localtime

yum install sudo -y
vi /etc/sudoers
