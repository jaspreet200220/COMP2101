#!/bin/bash

######-------------ROOT PRIVILAGE MESSAGE------------------########

#if the script we run has root privilage it will run otherwise it will exit.
if  [ "$(id -u)" != 0 ] ; then 
	echo "You need to be root for this script.";
	exit 1
fi

source ./reportfunctions.sh


#####-------------------END OF ROOT PRIVILAGE MESSAGE-----------------------#####




#####--------------DISPLAY GENERAL PROPERTIES-----------------#####



#Command for system’s fully-qualified domain name. Assign a variable to print it.
FQDN=$(hostname -f)

#Command to find the total space available in the system.
Availablespace=$(df / -h | awk 'FNR == 2 {print $4}')

#Command for the  IP addresses of the system.
Ipaddress=$(hostname -I)



#####----------------END OF DISPLAY GENERAL PROPERTIES----------------#####


#####----------------ERROR MESSAGE WITH A TIMESTAMP------------------#####

#Assigning the variables

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
	errorMessage
fi


#network runs networkreport
if [[ "$networkReport" == true ]]; then
	fullReport=false
	networkreport
	
fi



#disk runs only the diskreport	
if [[ "$diskReport" == true ]]; then
	fullReport=false
	
	diskreport
fi

#system runs only the computerreport, osreport, cpureport, ramreport, and videoreport
if [[ "$systemReport" == true ]]; then 
	fullReport=false
	computerreport
	
	cpureport
	
	osreport
	
	videoreport
	
	ramreport
	
	videoreport
	
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

	


























