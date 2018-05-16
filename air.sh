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

# usage: msg {input|error|success|failed|em|msg} "message body"
msg()
{
	local debug=0

	if [ $1 = "input" ]; then
		read -p "press [enter] to ${@:2}." KEY
	else
		case $1 in
			error)
				local fcolor=1   # red
				local bcolor=239 # dark gray
				local header="  ERROR  "
				local footer="         "
				;;
			success)
				local fcolor=240 # dark gray
				local bcolor=40  # green
				local header=" success "
				local footer=""
				;;
			failed)
				local fcolor=15  # white
				local bcolor=161 # magenta
				local header=" failed  "
				local footer=""
				;;
			em)
				local fcolor=33 # cyan
				local bcolor=33 # cyan
				local header="         "
				local footer=""
				;;
			msg)
				local fcolor=15  # white
				local bcolor=239 # dark gray
				local header="   msg   "
				local footer=""
				;;
			dbg)
				if [ ${debug} = 1 ];then
					local fcolor=233 # dark gray
					local bcolor=220 # yellow
					local header="  debug  "
					local footer=""
				else
					return
				fi
				;;
			*)
				local fcolor=15 # white
				local bcolor=15 # white
				local footer=""
				;;
		esac

		local f="\x1b[38;05;${fcolor}m" # foreground color
		local b="\x1b[48;05;${bcolor}m" # background color
		local reset="\033[00m"
		local header="${f}${b}${header}${reset} "
		local footer=" ${f}${b}${footer}${reset}\n"

		printf "${header}${@:2}${footer}"
	fi
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
