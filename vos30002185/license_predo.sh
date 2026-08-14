#!/bin/sh

. ./common_function.sh

VOS_USER_NAME=""
if [ -d /home/kunshi ]; then
	VOS_USER_NAME=kunshi
elif [ -d /home/sanntuu ]; then
	VOS_USER_NAME=sanntuu
else
	echo_error_message "no kunshi user"
	exit 1
fi

EXIT_CODE=0

create_jdk_env()
{
	VOS_JDK_DIR=/home/$VOS_USER_NAME/base/jdk_default
	if [ ! -d $VOS_JDK_DIR ];then
		echo_error_message "Missing jdk directory $VOS_JDK_DIR"
		return 1
	fi
	JDK_ENV_FILE=/home/$VOS_USER_NAME/.jdk_env
	if [ -f $JDK_ENV_FILE ];then
		return 0
	fi
	echo "export JAVA_HOME=$VOS_JDK_DIR " >> $JDK_ENV_FILE
	echo 'export PATH=$$VOS_JDK_DIR/bin:$PATH ' >> $JDK_ENV_FILE
	ARCH=`getconf LONG_BIT`
	if [ "$ARCH" != "64" ];then
		echo "export LD_LIBRARY_PATH=$VOS_JDK_DIR/jre/lib/i386/jrockit/:$VOS_JDK_DIR/jre/lib/i386/server/:$LD_LIBRARY_PATH " >> $JDK_ENV_FILE	
	else
		echo "export LD_LIBRARY_PATH=$VOS_JDK_DIR/jre/lib/amd64/jrockit/:$VOS_JDK_DIR/jre/lib/amd64/server/:$LD_LIBRARY_PATH " >> $JDK_ENV_FILE	
	fi
	chown $VOS_USER_NAME:$VOS_USER_NAME $JDK_ENV_FILE
	chmod 660 $JDK_ENV_FILE
	if [ -f /home/$VOS_USER_NAME/.bashrc ];then
		grep $JDK_ENV_FILE /home/$VOS_USER_NAME/.bashrc > /dev/null 2>&1
		[ "$?" != 0 ] && { echo '. /home/$VOS_USER_NAME/.jdk_env' >> /home/$VOS_USER_NAME/.bashrc;}
	fi
	return 0
}

chage -l $VOS_USER_NAME > /dev/null 2>&1
if [ "$?" != "0" ];then
	echo_error_message "Can not find user $VOS_USER_NAME"
#	exit 1
fi

create_jdk_env
if [ "$?" != "0" ];then
	EXIT_CODE=1
fi

SOFTWARE_OLD_VERSION=`rpm --qf "%{Version}" -q MySQL-server-community 2>/dev/null`
#if [ "$?" != "0" -o "$SOFTWARE_OLD_VERSION" != "5.0.96" ];then
if [ "$?" != "0" ]; then
	echo_error_message "MySQL-server-community 5.0.96 not installed"
#	EXIT_CODE=1
fi

SOFTWARE_OLD_VERSION=`rpm --qf "%{Version}" -q MySQL-client-community 2>/dev/null`
#if [ "$?" != "0" -o "$SOFTWARE_OLD_VERSION" != "5.0.96" ];then
if [ "$?" != "0" ]; then
	echo_error_message "MySQL-client-community not installed"
#	EXIT_CODE=1
fi



exit $EXIT_CODE
