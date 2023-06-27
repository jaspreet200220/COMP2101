#!/bin/bash
#echo commands are used to display labels

#Hostname command to display information about fqdn
fqdn=$(hostname -f)

#Hostnamectl display OS info with awk command to only get required data
hostname=$(hostnamectl | awk 'FNR == 7 {print $3, $4, $5}')


ip=$(hostname -I)

#df command runs along -h option for readable format to get data
freespace=$(df / -h | awk 'FNR == 2 {print $4}')


cat <<EOF
                Report
----------------------------------------
FQDN: $fqdn
Operating System name and version: $hostname
IP Address: $ip
Root Filesystem Free Space: $freespace
----------------------------------------
EOF
