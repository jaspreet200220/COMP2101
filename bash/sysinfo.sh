#!/bin/bash

##################################################################################################

#if the script we run has root privilage and if not, exit.
if  [ "$(id -u)" != 0 ] ; then 
	echo "You need to be root for this script.";
	exit 1
fi

source ./reportfunctions.sh

###################################################################################################

#Heading and command for system’s fully-qualified domain name
FQDN=$(hostname -f)

#Heading and command for the  IP addresses
IP_Address=$(hostname -I)

#Heading and command for amount of space available
Space_Available=$(df / -h | awk 'FNR == 2 {print $4}')

##############################  error message to the user on stderr #################################

log_errors() {
    somecommand 2> >(logger -t "$(basename "$0")" -i -p user.warning)
}

# usage
log_errors

############################# error message with a timestamp #######################################

#
verbose=false
systemReport=false
diskReport=false
networkReport=false
fullReport=true

while [ $# -gt 0 ]; do
	case ${1} in
		-h | --help)
		displayhelp
		exit 0
		;;
		-v | --verbose)
		verbose=true
		;;
		-s | --system)
		systemReport=true
		;;
		-d | --disk)
		diskReport=true
		;;
		-n | --network)
		networkReport=true
		;;
		*)
		echo "invalid option
		Usage: sysinfo.sh[Options]
		try 'sysinfo.sh --help' for information"
		errormessage "@"
		exit 1
		;;
	esac
	shift
done
#-v runs your script verbosely, showing any errors to the user instead of sending them to the logfile
if [[ "$verbose" == true ]]; then
	fullReport=false
	errormessage
fi
#system runs only the computerreport, osreport, cpureport, ramreport, and videoreport
if [[ "$systemReport" == true ]]; then 
	fullReport=false
	cpureport
	ramreport
	videoreport
	computerreport
	osreport
fi

#disk runs only the diskreport	
if [[ "$diskReport" == true ]]; then
	fullReport=false
	diskreport
fi

#network runs only the networkreport
if [[ "$networkReport" == true ]]; then
	fullReport=false
	networkreport
	
fi

#Print the full report
if [[ "$fullReport" == true ]]; then
	fullReport=false
	diskreport
	cpureport
	ramreport
	videoreport
	computerreport
	osreport
	networkreport
fi	
	


























