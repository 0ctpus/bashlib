#!/usr/bin/env bash

# directory tree
# |
# +------ ${g_dirpath}/
# |  |
# |  +--- ${g_filepath}
# |
# +------ ${g_logpath}/

declare -r g_filepath=$(readlink -f $0)
declare -r g_dirpath=$(dirname ${g_filepath})
declare -r g_logpath=$(dirname ${g_dirpath})"/log"

declare -r g_user="user"
declare -r g_nip="1.1.1."
declare -r g_identity=${g_dirpath}"/auth/key"
declare -ar g_device=("1" "2" "3")

declare -r g_sendpath=${g_dirpath}
declare -r g_receivepath="/home/"${g_user}

input()
{
	read -p "press [enter] to ${@:2}." KEY
}

cmdchk(){
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
	if [ ${1} = "input" ]; then
		read -p "press [enter] to ${@:2}." KEY
	else
		case ${1} in
			error)
				local fcolor=0 # black
				local bcolor=1 # red
				local header="  ERROR  "
				local footer=""
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
					return 0
				fi
				;;
			*)
				local fcolor=15  # white
				local bcolor=239 # dark gray
				local header="  ${1}  "
				local footer=""
				;;
		esac

		local f="\x1b[38;05;${fcolor}m" # foreground color
		local b="\x1b[48;05;${bcolor}m" # background color
		local reset="\033[00m"
		local header="${f}${b}${header}${reset} "
		local footer=" ${f}${b}${footer}${reset}\n"

		shift
		printf "${header}${@}${footer}"
	fi
}

watch_start(){
	SECONDS=0
}

watch_end(){
	echo "running time:${SECONDS} [s]"
}

show(){
	for opt in ${@}
	do
		case $opt in
			-p)
				printf "${1}"
				;;
			*)
				;;
		esac
	done
}

loop(){
	for opt in ${@}
	do
		case $opt in
			-s)
				printf "${1}"
				;;
			*)
				;;
		esac
	done

	while true
	do
		${@:1}
	done
}
#!/usr/bin/env bash

# var
# funcitons
msg()
{
	if [ ${1} = "input" ]; then
		read -p "press [enter] to ${@:2}." KEY
	else
		case ${1} in
			error)
				local fcolor=0 # black
				local bcolor=1 # red
				local header="  ERROR  "
				local footer=""
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
			*)
				local fcolor=15  # white
				local bcolor=239 # dark gray
				local header="  ${1}  "
				local footer=""
				;;
		esac

		local f="\x1b[38;05;${fcolor}m" # foreground color
		local b="\x1b[48;05;${bcolor}m" # background color
		local reset="\033[00m"
		local header="${f}${b}${header}${reset} "
		local footer=" ${f}${b}${footer}${reset}\n"

		shift
		printf "${header}${@}${footer}"
	fi
}

rtnchk(){
	local -i rtn=${1}
	if [ ${rtn} = 0 ]
	then
		local rtnmsg="success"
	else
		local rtnmsg="failed"
	fi
	msg ${rtnmsg} "\n"
}

cmd(){
	local cmd=${@}
	for hip in ${g_device[@]}
	do
		msg msg "ssh to ${g_nip}${hip}"
		msg ">" "${cmd}"
		if [ -e ${g_identity} ]
		then
			ssh -i ${g_identity} ${g_user}@${g_nip}${hip} ${cmd}
		else
			ssh ${g_user}@${g_nip}${hip} ${cmd}
		fi
		local -i rtn=${?}
		rtnchk ${rtn}
	done
}

send(){
	for hip in ${g_device[@]}
	do
		msg msg "send to ${g_nip}${hip}:${g_receivepath}"
	if [ -d ${g_sendpath} ]
	then
		if [ -e ${g_identity} ]
		then
			scp -r -i ${g_identity} ${g_sendpath}* ${g_user}@${g_nip}${hip}:${g_receivepath}
		else
			scp -r ${g_sendpath}* ${g_user}@${g_nip}${hip}:${g_receivepath}
		fi
	else
		echo "error"
		return 1
	fi
	local -i rtn=${?}
	rtnchk ${rtn}
	done
}
