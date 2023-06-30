lsblkOutput=$(lsblk)
dmidecodeOutput=$(dmidecode)
lshwOutput=$(lshw)
lscpuOutput=$(lscpu)


############################################# CPU INFORMATION ##################################################
function cpuReport {

	#Cmd to get the cpu manufacturer.
	cpumanufac=$(echo "$lshwOutput" | grep 'Model name:' | sed 's/,"Model name: *//') 
	if [ -z "$cmpdescription" ]; then 
		cpumanufac='Error! Data is unavailable.'
	else
		cpumanufac=$(echo "$lscpuOutput" | grep 'Model name:' | sed 's/,"Model name: *//')
	fi
	#-----------------------------------------------------------------------------------------------
	#Cmd to get the Cpu architecture.
	cpuarchi=$(echo "$lscpuOutput" | grep 'Architecture: ' | awk '{print$2}')
	if [ -z "$cmpdescription" ]; then 
		cpuarchi='Error! Data is unavailable.'
	else
		cpuarchi=$(echo "$lscpuOutput" | grep 'Architecture: ' | awk '{print$2}')
	fi
	#-----------------------------------------------------------------------------------------------
	#Cmd to get the Cpu core count.
	cpucore=$(echo "$lscpuOutput" | grep 'CPU(s): ' | head -1 | awk '{print$2}')
	if [ -z "$cmpdescription" ]; then 
		cpucore='Error! Data is unavailable.'
	else
		cpucore=$(echo "$lscpuOutput" | grep 'CPU(s): ' | head -1 | awk '{print$2}')
	fi
	#-----------------------------------------------------------------------------------------------
	#Cmd to get the Cpu maximum speed.
	cpuspeed=$(echo "$lshwOutput" -class cpu | grep 'capacity: ' | head -1 | awk '{print$2}')
	if [ -z "$cmpdescription" ]; then 
		cpuspeed='Error! Data is unavailable.'
	else
		cpuspeed=$(echo "$lshwOutput" -class cpu | grep 'capacity: ' | head -1 | awk '{print$2}')
	fi
	#-----------------------------------------------------------------------------------------------
	#Cmd to get the size of L1d.
	sizeL1d=$(echo "$lscpuOutput" | grep 'L1d ' | awk '{print $3}')
	if [ -z "$cmpdescription" ]; then 
		sizeL1d='Error! Data is unavailable.'
	else
		sizeL1d=$(echo "$lscpuOutput" | grep 'L1d ' | awk '{print $3}')
	fi
	#-----------------------------------------------------------------------------------------------
	#Cmd to get the size of L1i.
	sizeL1i=$(echo "$lscpuOutput" | grep 'L1i ' | awk '{print $3}')
	if [ -z "$cmpdescription" ]; then 
		sizeL1i='Error! Data is unavailable.'
	else
		sizeL1i=$(echo "$lscpuOutput" | grep 'L1i ' | awk '{print $3}')
	fi
	#-----------------------------------------------------------------------------------------------
	#Cmd to get the size of L2.
	sizeL2=$(echo "$lscpuOutput" | grep 'L2' | awk '{print $3}')
	if [ -z "$cmpdescription" ]; then 
		sizeL2='Error! Data is unavailable.'
	else
		sizeL2=$(echo "$lscpuOutput" | grep 'L2 ' | awk '{print $3}')
	fi
	#-----------------------------------------------------------------------------------------------
	#Cmd to get the size of L3.
	sizeL3=$(echo "$lscpuOutput" | grep 'L3' | awk '{print $3}')
	if [ -z "$cmpdescription" ]; then 
		sizeL3='Error! Data is unavailable.'
	else
		sizeL3=$(echo "$lscpuOutput" | grep 'L3 ' | awk '{print $3}')
	fi

cat <<-EOF
	
------ CPU INFORMATION------
CPU manufacturer and model=$cpumanufac
CPU architecture=              $cpuarchi
CPU core count=                $cpucore
CPU maximum speed=             $cpuspeed
Size of caches (L1d)=          $sizeL1d
Size of caches (L1i)=          $sizeL1i
Size of caches (L2)=           $sizeL2
Size of caches (L3)=           $sizeL3
EOF
}

################################################## Network Report ##################################################
function networkReport() {
	interfaceDescription=$(lshw -C network | grep -i 'description:' | awk '{print $1, $2, $3}')
	if [ -z "$interfaceDescription" ]; then 
		interfaceDescription='Error! Data is unavailable.'
	else
		interfaceDescription=$(lshw -C network | grep -i 'description:' | awk '{print $1, $2, $3}')
	fi

	interfaceManu=$(lshw -C network | grep -i 'vendor:' | awk '{print $2, $3}')
	if [ -z "$interfaceManu" ]; then 
		interfaceManu='Error! Data is unavailable.'
	else
		interfaceManu=$(lshw -C network | grep -i 'vendor:' | awk '{print $2, $3}')
	fi

	interSpeed=$(ethtool ens33 | grep 'Speed:' | awk '{print $2}')
	if [ -z "$interSpeed" ]; then 
		interSpeed='Error! Data is unavailable.'
	else
		interSpeed=$(ethtool ens33 | grep 'Speed:' | awk '{print $2}')
	fi

	interIpAdd=$(ip -4 addr show | awk '/inet /{print $2}')
	if [ -z "$interIpAdd" ]; then 
		interIpAdd='Error! Data is unavailable.'
	else
		interIpAdd=$(ip -4 addr show | awk '/inet /{print $2}')
	fi

	interBridgeMaster=$(sudo brctl show | awk 'NR > 1 {print $1, $4}')
	if [ -z "$interBridgeMaster" ]; then 
		interBridgeMaster='N/A'
	else
		interBridgeMaster=$(sudo brctl show | awk 'NR > 1 {print $1, $4}')
	fi

	DNSserver=$(cat /etc/resolv.conf | grep "nameserver" | awk '{print $2}')
	if [ -z "$DNSserver" ]; then 
		DNSserver='N/A'
	else
		DNSserver=$(cat /etc/resolv.conf | grep "nameserver" | awk '{print $2}')
	fi

	searchDomain=$(cat /etc/resolv.conf | grep "search" | awk 'NR == 2 {print $2}')
	if [ -z "$searchDomain" ]; then 
		searchDomain='Error! Data is unavailable.'
	else
		searchDomain=$(cat /etc/resolv.conf | grep "search" | awk 'NR == 2 {print $2}')
	fi

	interfaceTable=$(paste -d ';' <(echo "$interfaceDescription") <(echo "$interfaceManu") <(echo "$interSpeed") <(echo "$interIpAdd") <(echo "$interBridgeMaster") <(echo "$DNSserver") <(echo "$searchDomain") | column -N 'Interface description',Manufacturer,'Interface Speed','Ip Address','Bridge Master','DNS Server','Search Domain' -s ';' -o ' | ' -t)

cat <<-EOF
-NETWORK INFORMATION-
$interfaceTable
EOF

}

########################################################## Storage Information ##############################################################

function storageReport() {
	driveManufacturer0=$(echo "$lshwOutput" | grep -A10 '\*\-disk' | grep 'vendor:' | awk '{$1=""; print $0}')
	if [ -z "$driveManufacturer0" ]; then 
		driveManufacturer0='Error! Data is unavailable.'
	else
		driveManufacturer0=$(echo "$lshwOutput" | grep -A10 '\*\-disk' | grep 'vendor:' | awk '{$1=""; print $0}')
	fi

	drivevendor1=$(echo "$lshwOutput" | grep -m1 -A8 "\-volume:0" | grep 'vendor:' | awk '{$1=""; print $0}')
	if [ -z "$drivevendor1" ]; then 
		drivevendor1='Error! Data is unavailable.'
	else
		drivevendor1=$(echo "$lshwOutput" | grep -m1 -A8 "\-volume:0" | grep 'vendor:' | awk '{$1=""; print $0}')
	fi

	drivevendor2=$(echo "$lshwOutput" | grep -m1 -A8 "\-volume:1" | grep 'vendor:' | awk '{$1=""; print $0}')
	if [ -z "$drivevendor1" ]; then 
		drivevendor2='Error! Data is unavailable.'
	else
		drivevendor2=$(echo "$lshwOutput" | grep -m1 -A8 "\-volume:1" | grep 'vendor:' | awk '{$1=""; print $0}')
	fi

	drivevendor3=$(echo "$lshwOutput" | grep -m1 -A8 "\-volume:2" | grep 'vendor:' | awk '{$1=""; print $0}')
	if [ -z "$drivevendor3" ]; then 
		drivevendor3='Error! Data is unavailable.'
	else
		drivevendor3=$(echo "$lshwOutput" | grep -m1 -A8 "\-volume:2" | grep 'vendor:' | awk '{$1=""; print $0}')
	fi

	driveModel=$(echo "$lshwOutput" | grep -m1 -A10 "\-disk" | grep 'product:' | awk '{$1=""; print $0}')
	if [ -z "$driveModel" ]; then 
		driveModel='Error! Data is unavailable.'
	else
		driveModel=$(echo "$lshwOutput" | grep -m1 -A10 "\-disk" | grep 'product:' | awk '{$1=""; print $0}')
	fi

	driveSize0=$(echo "$lsblkOutput" | grep "sda" | awk 'FNR==1 {print $4"B"}')
	if [ -z "$driveSize0" ]; then 
		driveSize0='Error! Data is unavailable.'
	else
		driveSize0=$(echo "$lsblkOutput" | grep "sda" | awk 'FNR==1 {print $4"B"}')
	fi

	driveSize1=$(echo "$lsblkOutput" | grep "sda" | awk 'FNR==2 {print $4"B"}')
	if [ -z "$driveSize1" ]; then 
		driveSize1='Error! Data is unavailable.'
	else
		driveSize1=$(echo "$lsblkOutput" | grep "sda" | awk 'FNR==2 {print $4"B"}')
	fi

	driveSize2=$(echo "$lsblkOutput" | grep "sda" | awk 'FNR==3 {print $4"B"}')
	if [ -z "$driveSize2" ]; then 
		driveSize2='Error! Data is unavailable.'
	else
		driveSize2=$(echo "$lsblkOutput" | grep "sda" | awk 'FNR==3 {print $4"B"}')
	fi

	driveSize3=$(echo "$lsblkOutput" | grep "sda" | awk 'FNR==4 {print $4"B"}')
	if [ -z "$driveSize3" ]; then 
		driveSize3='Error! Data is unavailable.'
	else
		driveSize3=$(echo "$lsblkOutput" | grep "sda" | awk 'FNR==4 {print $4"B"}')
	fi

	drivePartition0=$(echo "$lsblkOutput" | grep "sda" | awk 'FNR==1 {print $1}')
	if [ -z "$drivePartition0" ]; then 
		drivePartition0='Error! Data is unavailable.'
	else
		drivePartition0=$(echo "$lsblkOutput" | grep "sda" | awk 'FNR==1 {print $1}')
	fi

	drivePartition1=$(echo "$lsblkOutput" | grep "sda1" | awk 'FNR==1 {print $1}' | tail -c 5)
	if [ -z "$drivePartition1" ]; then 
		drivePartition1='Error! Data is unavailable.'
	else
		drivePartition1=$(echo "$lsblkOutput" | grep "sda1" | awk 'FNR==1 {print $1}' | tail -c 5)
	fi

	drivePartition2=$(echo "$lsblkOutput" | grep "sda2" | awk 'FNR==1 {print $1}' | tail -c 5)
	if [ -z "$drivePartition2" ]; then 
		drivePartition2='Error! Data is unavailable.'
	else
		drivePartition2=$(echo "$lsblkOutput" | grep "sda2" | awk 'FNR==1 {print $1}' | tail -c 5)
	fi

	drivePartition3=$(echo "$lsblkOutput" | grep "sda3" | awk 'FNR==1 {print $1}' | tail -c 5)
	if [ -z "$drivePartition3" ]; then 
		drivePartition3='Error! Data is unavailable.'
	else
	drivePartition3=$(echo "$lsblkOutput" | grep "sda3" | awk 'FNR==1 {print $1}' | tail -c 5)
	fi

	driveMountPoint0=$(echo "$lsblkOutput" | grep "sda" | awk 'FNR==1 {print $7}')
	if [ -z "$driveMountPoint0" ]; then 
		driveMountPoint0='Error! Data is unavailable.'
	else
		driveMountPoint0=$(echo "$lsblkOutput" | grep "sda" | awk 'FNR==1 {print $7}')
	fi

	driveMountPoint1=$(echo "$lsblkOutput" | grep "sda" | awk 'FNR==2 {print $7}')
	if [ -z "$driveMountPoint1" ]; then 
		driveMountPoint1='Error! Data is unavailable.'
	else
		driveMountPoint1=$(echo "$lsblkOutput" | grep "sda" | awk 'FNR==2 {print $7}')
	fi

	driveMountPoint2=$(echo "$lsblkOutput" | grep "sda" | awk 'FNR==3 {print $7}')
	if [ -z "$driveMountPoint2" ]; then 
		driveMountPoint2='Error! Data is unavailable.'
	else
		driveMountPoint2=$(echo "$lsblkOutput" | grep "sda" | awk 'FNR==3 {print $7}')
	fi

	driveMountPoint3=$(echo "$lsblkOutput" | grep "sda" | awk 'FNR==4 {print $7}')
	if [ -z "$driveMountPoint3" ]; then 
		driveMountPoint3='Error! Data is unavailable.'
	else
		driveMountPoint3=$(echo "$lsblkOutput" | grep "sda" | awk 'FNR==4 {print $7}')
	fi

	driveFilesystemSizeSDA2=$(echo "$lsblkOutput" | grep "sda2" | awk '{print $2"B"}')
	if [ -z "$driveFilesystemSizeSDA2" ]; then 
		driveFilesystemSizeSDA2='Error! Data is unavailable.'
	else
		driveFilesystemSizeSDA2=$(echo "$lsblkOutput" | grep "sda2" | awk '{print $2"B"}')
	fi

	driveFilesystemSizeSDA3=$(echo "$lsblkOutput" | grep "sda3" | awk '{print $2"B"}')
	if [ -z "$driveFilesystemSizeSDA3" ]; then 
		driveFilesystemSizeSDA3='Error! Data is unavailable.'
	else
		driveFilesystemSizeSDA3=$(echo "$lsblkOutput" | grep "sda3" | awk '{print $2"B"}')
	fi

	driveFilesystemFreeSDA2=$(echo "$lsblkOutput" | grep "sda2" | awk '{print $4"B"}')
	if [ -z "$driveFilesystemFreeSDA2" ]; then 
		driveFilesystemFreeSDA2='Error! Data is unavailable.'
	else
		driveFilesystemFreeSDA2=$(echo "$lsblkOutput" | grep "sda2" | awk '{print $4"B"}')
	fi

	driveFilesystemFreeSDA3=$(echo "$lsblkOutput" | grep "sda3" | awk '{print $4"B"}')
	if [ -z "$driveFilesystemFreeSDA3" ]; then 
		driveFilesystemFreeSDA3='Error! Data is unavailable.'
	else
		driveFilesystemFreeSDA3=$(echo "$lsblkOutput" | grep "sda3" | awk '{print $4"B"}')
	fi


	diskTable=$(paste -d ';' <(echo "$drivePartition0" ; echo "$drivePartition1" ; echo "$drivePartition2" ; echo "$drivePartition3") <(echo "$driveManufacturer0" ; echo "$drivevendor1" ; echo "$drivevendor2" ; echo "$drivevendor3") <(echo "$driveModel" ; echo "N/A" ; echo "N/A" ; echo "N/A") <(echo "$driveSize0" ; echo "$driveSize1" ; echo "$driveSize2" ; echo "$driveSize3") <(echo "N/A" ; echo "N/A" ; echo "$driveFilesystemSizeSDA2" ; echo "$driveFilesystemSizeSDA3") <(echo "N/A" ; echo "N/A" ; echo "$driveFilesystemFreeSDA2" ; echo "$driveFilesystemFreeSDA3") <(echo "$driveMountPoint0" ; echo "$driveMountPoint1" ; echo "$driveMountPoint2" ; echo "$driveMountPoint3") | column -N 'Partition Name (/dev/sda)',Vendor,Model,Size,'Filesystem Size','Filesystem Free Space','Mount Point' -s ';' -o ' | ' -t) 

cat <<EOF
-DISK INFORMATION-
$diskTable
EOF
	}

####################### RAM INFORMATION ##############################

function ramReport() {
	ramManufacturer=$(echo "$dmidecodeOutput" | grep -m1 -i "manufacturer" | awk '{$1=""; print $0}')
	if [ -z "$ramManufacturer" ]; then 
		ramManufacturer='Error! Data is unavailable.'
	else
		ramManufacturer=$(echo "$dmidecodeOutput" | grep -m1 -i "manufacturer" | awk '{$1=""; print $0}')
	fi

	ramProductName=$(echo "$dmidecodeOutput" | grep -m1 -i "Product name" | awk '{$1=""; $2=""; print $0}')
	if [ -z "$ramProductName" ]; then 
		ramProductName='Error! Data is unavailable.'
	else
		ramProductName=$(echo "$dmidecodeOutput" | grep -m1 -i "Product name" | awk '{$1=""; $2=""; print $0}')
	fi

	ramSerialNum=$(echo "$dmidecodeOutput" | grep -m1 -i "serial number" | awk '{$1=""; print $0}')
	if [ -z "$ramSerialNum" ]; then 
		ramSerialNum='Error! Data is unavailable.'
	else
		ramSerialNum=$(echo "$dmidecodeOutput" | grep -m1 -i "serial number" | awk '{$1=""; print $0}')
	fi

	ramSize=$(echo "$lshwOutput" | grep -A10 "\-memory" | grep 'size:' | awk 'FNR == 2 {$1=""; print $0}')
	if [ -z "$ramSize" ]; then 
		ramSize='Error! Data is unavailable.'
	else
		ramSize=$(echo "$lshwOutput" | grep -A10 "\-memory" | grep 'size:' | awk 'FNR == 2 {$1=""; print $0}')
	fi

	ramSpeed=$(echo "$dmidecodeOutput" --type 17 | grep -m1 Speed | awk '{$1=""; print $0}')
	if [ -z "$ramSpeed" ]; then 
		ramSpeed='Error! Data is unavailable.'
	else
		ramSpeed=$(echo "$dmidecodeOutput" --type 17 | grep -m1 Speed | awk '{$1=""; print $0}')
	fi

	ramLocation=$(echo "$lshwOutput" | grep -m1 'slot: RAM' |awk '{$1=""; $2=""; print $0}')
	if [ -z "$ramLocation" ]; then 
		ramLocation='Error! Data is unavailable.'
	else
		ramLocation=$(echo "$lshwOutput" | grep -m1 'slot: RAM' |awk '{$1=""; $2=""; print $0}')
	fi

	totalSize=$(echo "$lshwOutput" | grep -A5 "\-memory" | grep -m1 'size:' | awk '{$1=""; print $0}')
	if [ -z "$totalSize" ]; then 
		totalSize='Error! Data is unavailable.'
	else
		totalSize=$(echo "$lshwOutput" | grep -A5 "\-memory" | grep -m1 'size:' | awk '{$1=""; print $0}')
	fi

	ramTable=$(paste -d ';' <(echo "$ramManufacturer") <(echo "$ramProductName") <(echo "$ramSerialNum") <(echo "$ramSize") <(echo "$ramSpeed") <(echo "$ramLocation") <(echo "$totalSize") | column -N Manufacturer,Model,'Seial Number',Size,Speed,Location,'Total size' -s ';' -o ' | ' -t)	

cat <<EOF
-RAM INFORMATION-
$ramTable
EOF
}


####################### Video Report ##############################

function videoReport() {
	videoManu=$(lshw -class display | grep "vendor:" | awk '{print $2}')
	if [ -z "$videoManu" ]; then 
		videoManu='Error! Data is unavailable.'
	else
		videoManu=$(lshw -class display | grep "vendor:" | awk '{print $2}')
	fi

	videoDescription=$(lshw -C display | grep 'description:' | awk '{$1=""; print $0}')
	if [ -z "$videoDescription" ]; then 
		videoDescription='Error! Data is unavailable.'
	else
		videoDescription=$(lshw -C display | grep 'description:' | awk '{$1=""; print $0}')
	fi

cat <<EOF
-VIDEO INFORMATION-
Manufacturer=$videoManu
Description=$videoDescription
EOF

	}


############################################## COMPUTER INFORMATION ################################################


function cmpReport() {
	#Cmd to get the computer manufacturer.
	cmpmanuftr=$(echo "$lshwOutput" -class system | grep 'vendor:' | head -1 | awk '{$1=""; print $0}') 
	if [ -z "$cmpmanuftr" ]; then
		cmpmanuftr='Error! Data is unavailable.'
	else
		cmpmanuftr=$(echo "$lshwOutput" -class system | grep 'vendor:' | head -1 | awk '{$1=""; print $0}')
	fi
	#-----------------------------------------------------------------------------------------------
	#Cmd to get the Computer description or model.
	cmpdescription=$(echo "$lshwOutput" -class system | grep -m1 -i 'description:' | awk '{print $2}')
	if [ -z "$cmpdescription" ]; then 
		cmpdescription='Error! Data is unavailable.'
	else
		cmpdescription=$(echo "$lshwOutput" -class system | grep -m1 -i 'description:' | awk '{print $2}')
	fi
	#-----------------------------------------------------------------------------------------------
	#Cmd to get the Computer serial number.
	cmpserial=$(echo "$lshwOutput" -class system | grep -m1 -i 'serial: ' | awk '{$1=""; print $0}')
	if [ -z "$cmpdescription" ]; then 
		cmpserial='Error! Data is unavailable.'
	else
		cmpserial=$(echo "$lshwOutput" -class system | grep -m1 -i 'serial: ' | awk '{$1=""; print $0}')
	fi

cat <<EOF
-SYSTEM DESCRIPTION-
Computer manufacturer=         $cmpmanuftr
Computer description or model=  $cmpdescription
Computer serial number=        $cmpserial
EOF

}	

####################################### OS INFORMATION ################################################

function osReport() {
	#Cmd to get Os distro version.
	distroversion=$(hostnamectl | grep 'Kernel: ' | awk '{$1=""; print $0}')
	if [ -z "$cmpdescription" ]; then 
		distroversion='Error! Data is unavailable.'
	else
		distroversion=$(hostnamectl | grep 'Kernel: ' | awk '{$1=""; print $0}')
	fi

	#Heading and command for The operating system name and version
	Host_Information=$(hostnamectl | awk 'FNR == 7 {print $3, $4, $5}')
cat <<EOF
-OS INFORMATION-
-OS INFOPRMATION-
Linux distro=                  $Host_Information
Distro version=               $distroversion
EOF

}

