#!/usr/bin/env bash

input()
{
	read -p "press [enter] to ${@:2}." KEY
}

chk_exist(){
	local rslt=0;
	if ! type ${1} >/dev/null 2>&1
	then
		result=1
	fi
	return ${rslt}
}

msg(){
	local HEADER="|-- [${1}] "
	case ${1} in
		success)
			local COLOR=47 # GREEN
			local HEADER=${HEADERTYPE1}
			local FOOTER=""
			;;
		failed)
			local COLOR=197 #RED
			local HEADER=${HEADERTYPE1}
			local FOOTER=""
			;;
		msg)
			local COLOR=216 #ORANGE
			local HEADER="|-- [msg] "
			local FOOTER=""
			;;
		*)
			local COLOR=15 #WHITE
			local HEADER=${HEADER}
			local FOOTER=""
			;;
	esac
	local HEADER="\x1b[38;05;${COLOR}m${HEADER}"
	local FOOTER="${FOOTER}\033[00m\n"
	printf "${HEADER}${@:2}${FOOTER}"
}

watch_start(){
	SECONDS=0
}

watch_end(){
	echo "running time:${SECONDS} [s]"
}

show(){
	for opt in ${@}; do
		case $opt in
			-p)
				printf "${1}"
				;;
			*)
				;;
		esac
	done
}

# operator
++()
{
	$(( ${1}=${1}+1 )); show
}

+=()
{
	$(( ${1}=${1}+${2} )); show
}

--()
{
	$(( ${1}=${1}-1 )); show
}

-=()
{
	$(( ${1}=${1}-${2} )); show
}
