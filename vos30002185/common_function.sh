#!/bin/sh

check_command()
{
	MISSING_COMMANDS=""
	while [ "$1" != "" ]
	do
		type $1 > /dev/null 2>&1
		if [ "$?" != "0" ];then
			MISSING_COMMANDS="$MISSING_COMMANDS "$1
		fi
		shift 1
	done
	if [ "$MISSING_COMMANDS" != "" ];then
		echo -e "Missing commands \e[1m\e[31m$MISSING_COMMANDS\e[0;39m"
		exit 1
	fi
}

read_yes_or_no()
{
	echo -en "$1 [\e[1m\e[32mY\e[0;39m/n]:"
	read -n1 -p " " -e -r valueTmp
	[ "$valueTmp" != "n" -a "$valueTmp" != "N" ] && { return 0;}
	return 1
}

read_no_or_yes()
{
	echo -en "$1 [\e[1m\e[32mN\e[0;39m/y]:"
	read -n1 -p " " -e -r valueTmp
	[ "$valueTmp" != "y" -a "$valueTmp" != "Y" ] && { return 0;}
	return 1
}


echo_ok()
{
	echo -e " \033[66G[  \e[32mOk\e[0;39m  ]"
}
echo_finish()
{
	echo -e " \033[66G[\e[32mFinish\e[0;39m]"
}
echo_failed()
{
	echo -e " \033[66G[\e[1m\e[31;40mFailed\e[0;39m]"
}

echo_skipped()
{
	echo -e " \033[66G[\e[32;40mSkipped\e[0;39m]"
}
echo_download_ok()
{
	echo -e " \033[66G[  \e[1m\e[33mOk\e[0;39m  ]"
}

echo_replace()
{
	echo -e " \033[66G[\e[1m\e[33mReplace\e[0;39m]"
}
echo_upgrade()
{
	echo -e " \033[66G[\e[1m\e[33mUpgrade\e[0;39m]"
}
echo_install()
{
	echo -e " \033[66G[\e[1m\e[33mInstall\e[0;39m]"
}
echo_ignored()
{
	echo -e " \033[66G[\e[32;40mIgnored\e[0;39m]"
}

echo_error_message()
{
	echo -e "\e[1m\e[31m$1\e[0;39m"
}

echo_important_message()
{
	echo -e "\e[1m\e[33m$1\e[0;39m"
}

