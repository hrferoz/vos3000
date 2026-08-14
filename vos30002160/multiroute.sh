#!/bin/sh
TEMP_FILE=routes.rule
PREF_FIRST=100
PREF=$PREF_FIRST
echo -n > $TEMP_FILE
OS_NAME=""
if [ -f /etc/redhat-release ]
then
	OS_NAME="redhat"
elif uname -a |grep suse >/dev/null 2>&1
then
	OS_NAME="suse"
else
	echo "unsupported OS version"
	exit
fi

parseprefixsub()
{
	[ "$1" = 255 ] && { PREFIXSUB=8; return;}
	[ "$1" = 0 ] && { PREFIXSUB=0; return;}
	i=7
	let ipSub="1<<$i"
	while [ $i -gt 0 -a $ipSub != $1 ]; do
		i=`expr $i - 1`
		let ipSub\|="1<<$i"
	done
	PREFIXSUB=`expr 8 - $i`
}
parsenetprefix()
{
	PREFIX=0
	ipIndex=1
	while [ $ipIndex -le 4 ]; do
		parseprefixsub `eval echo $1 | cut -d'.' -f$ipIndex`
		let PREFIX+="$PREFIXSUB"
		[ $PREFIXSUB != 8 ] && break
		let ipIndex+=1
	done
}
parsenetwork()
{
	ipIndex=1
	NETWORKRET=""
	while [ $ipIndex -le 4 ]; do
		ipSub=`eval echo $1 | cut -d'.' -f$ipIndex`
		netSub=`eval echo $2 | cut -d'.' -f$ipIndex`
		let ipSub="$ipSub&$netSub"
		if [ "$ipIndex" = "4" ]; then
			NETWORKRET="$NETWORKRET""$ipSub"
		else
			NETWORKRET=$NETWORKRET"$ipSub""."
		fi
		let ipIndex+=1
	done
}

route -n|grep -v Gateway|grep -v Kernel|while read line;do
	GATEWAY=`echo $line|awk '{print $2}'`
	[ "$GATEWAY" != "0.0.0.0" ] && continue
	NETWORK=`echo $line|awk '{print $1}'`
	NETMASK=`echo $line|awk '{print $3}'`
	[ "$NETWORK" = "0.0.0.0" -o "$NETWORK" = "169.254.0.0" ] && continue
	DEV=`echo $line|awk '{print $8}'`
	[ "$DEV" = "lo" ] && continue
	echo NETWORK$PREF=$NETWORK >> $TEMP_FILE
	echo NETMASK$PREF=$NETMASK >> $TEMP_FILE
	echo DEV$PREF=$DEV >> $TEMP_FILE
	echo -n > $TEMP_FILE"."$DEV
	PREF=`expr $PREF + 1`
done
[ -f ./$TEMP_FILE ] && . ./$TEMP_FILE
PREF=$PREF_FIRST

echo -e "\n==========================================================="
echo -e "\n             Config multi default gateway"
echo -e "\n==========================================================="
while [ "$(eval echo '$'NETWORK$PREF)" != "" ]; do
		NETWORK="$(eval echo '$'NETWORK$PREF)"
		NETMASK="$(eval echo '$'NETMASK$PREF)"
		DEV="$(eval echo '$'DEV$PREF)"
		parsenetprefix $NETMASK
		echo -en "\nConfig $NETWORK/$PREFIX $DEV gateway[Y/n]:";read YESORNO
		[ "$YESORNO" = "n" -o "$YESORNO" = "N" ] && { PREF=`expr $PREF + 1`;continue; }
		while [ true ]; do
				echo -en "Gateway: "
				read valueTmp
				[ -z "$valueTmp" ] || gatewayIp=$valueTmp
				if [ "$gatewayIp" != "" ];then
					parsenetwork $gatewayIp $NETMASK
					if [ "$NETWORK" = "$NETWORKRET" ];then
						break
					else
						[ -z "$NETWORKRET" ] || echo -e "Gateway network is unreachable"
					fi
				fi
		done
		echo "ip route flush table $PREF > /dev/null 2>&1" >> $TEMP_FILE"."$DEV
		echo "ip rule del from $NETWORK/$PREFIX  > /dev/null 2>&1" >> $TEMP_FILE"."$DEV
		echo "[ \"\$1\" = \"down\" ] && exit" >> $TEMP_FILE"."$DEV
		echo "ip route add $NETWORK/$PREFIX dev $DEV table $PREF" >> $TEMP_FILE"."$DEV
		echo "ip route add default via $gatewayIp dev $DEV table $PREF" >> $TEMP_FILE"."$DEV
		echo "ip rule add from $NETWORK/$PREFIX table $PREF pref $PREF" >> $TEMP_FILE"."$DEV
		PREF=`expr $PREF + 1`
done

for file in $TEMP_FILE.*; do
	DEV=`echo $file|cut -d"." -f 3`
	RULEFILE=$TEMP_FILE"."$DEV
	case "$OS_NAME" in
		redhat)
			SCRIPT_DIR=/etc/sysconfig/network-scripts
			mv -f $RULEFILE $SCRIPT_DIR/$RULEFILE
			ROUTEFILE=$SCRIPT_DIR/$DEV"."route
			[ -f $ROUTEFILE ] || { echo -n > $ROUTEFILE; }
			cat $ROUTEFILE |grep -v "$SCRIPT_DIR/$RULEFILE" > /tmp/routetmp
			echo ". $SCRIPT_DIR/"$RULEFILE >> /tmp/routetmp
			mv -f /tmp/routetmp $ROUTEFILE
			;;
		suse)
			SCRIPT_DIR=/etc/sysconfig/network/scripts
			mv -f $RULEFILE $SCRIPT_DIR/$RULEFILE
			ROUTE_UP_FILE=/etc/sysconfig/network/if-up.d/multiroute
			ROUTE_DOWN_FILE=/etc/sysconfig/network/if-down.d/multiroute
			echo "[ -f $SCRIPT_DIR/$TEMP_FILE.$""2 ] && . $SCRIPT_DIR/$TEMP_FILE.$""2 up"> $ROUTE_UP_FILE
			echo "[ -f $SCRIPT_DIR/$TEMP_FILE.$""2 ] && . $SCRIPT_DIR/$TEMP_FILE.$""2 down"> $ROUTE_DOWN_FILE
			chmod +x $ROUTE_UP_FILE
			chmod +x $ROUTE_DOWN_FILE
			;;
		*)
			echo "unsupported OS"
			continue
			;;
	esac
done

rm -rf $TEMP_FILE*

echo -en "Flush route cache [Y/n]:";read YESORNO
[ "$YESORNO" = "n" -o "$YESORNO" = "N" ] && exit 0

case "$OS_NAME" in
	redhat)
		for file in /etc/sysconfig/network-scripts/$TEMP_FILE.*; do
			echo "enable "$file
			. $file up
		done
		;;
	suse)
		for file in /etc/sysconfig/network/scripts/$TEMP_FILE.*; do
			echo "enable "$file
			. $file up
		done
		;;
esac
ip route flush cache

