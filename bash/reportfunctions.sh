#Define the variables for lsblk, dmidecode, lshw, lscpu

lsblkOutput=$(lsblk)
dmidecodeOutput=$(dmidecode)
lshwOutput=$(lshw)
lscpuOutput=$(lscpu)


############################################# CPU INFORMATION ##################################################
function cpureport()  {

#Cmd to get the cpu manufacturer.
#lshw command used with model name to filter system hardware
#grep is used to get model name, while awk is used to print the 2nd itme field
#-z test command is used to check if the data is available or not by testing the variable and checking if it's empty or not. If empty an error is displayed
	cpumanufac=$(echo "$lshwOutput" | grep 'Model name:' | sed 's/,"Model name: *//') 
	if [ -z "$cpumanufac" ]; then 
		cpumanufac='Error! Data is unavailable.'
	else
		cpumanufac=$(echo "$lscpuOutput" | grep 'Model name:' | sed 's/,"Model name: *//')
	fi
#-----------------------------------------------------------------------------------------------
#Cmd to get the Cpu architecture.
#lscpu command used to display cpu information
#grep is used to get architecture, while awk is used to print the 2nd itme field
#-z test command is used to check if the data is available or not by testing the variable and checking if it's empty or not. If empty an error is displayed
	cpuarchi=$(echo "$lscpuOutput" | grep 'Architecture: ' | awk '{print$2}')
	if [ -z "$cpuarchi" ]; then 
		cpuarchi='Error! Data is unavailable.'
	else
		cpuarchi=$(echo "$lscpuOutput" | grep 'Architecture: ' | awk '{print$2}')
	fi
#-----------------------------------------------------------------------------------------------
#Cmd to get the Cpu core count.
#lscpu command used with class "system" to display cpu information
#grep is used to get CPU, while awk is used to print the 2nd itme field
#-z test command is used to check if the data is available or not by testing the variable and checking if it's empty or not. If empty an error is displayed
	cpucore=$(echo "$lscpuOutput" | grep 'CPU(s): ' | head -1 | awk '{print$2}')
	if [ -z "$cpucore" ]; then 
		cpucore='Error! Data is unavailable.'
	else
		cpucore=$(echo "$lscpuOutput" | grep 'CPU(s): ' | head -1 | awk '{print$2}')
	fi
#-----------------------------------------------------------------------------------------------
#Cmd to get the Cpu maximum speed.
#lshw command used with class "CPU" to display cpu information
#grep is used to get capacity, while awk is used to print the 2nd itme field
#-z test command is used to check if the data is available or not by testing the variable and checking if it's empty or not. If empty an error is displayed
	cpuspeed=$(echo "$lshwOutput" -class cpu | grep 'capacity: ' | head -1 | awk '{print$2}')
	if [ -z "$cpuspeed" ]; then 
		cpuspeed='Error! Data is unavailable.'
	else
		cpuspeed=$(echo "$lshwOutput" -class cpu | grep 'capacity: ' | head -1 | awk '{print$2}')
	fi
#-----------------------------------------------------------------------------------------------
#Cmd to get the size of L1d.
#lscpu command used with class "system" to display cpu information
#grep is used to get 'description' field, while awk is used to print the 2nd itme field
#-z test command is used to check if the data is available or not by testing the variable and checking if it's empty or not. If empty an error is displayed
	sizeL1d=$(echo "$lscpuOutput" | grep 'L1d ' | awk '{print $3}')
	if [ -z "$sizeL1d" ]; then 
		sizeL1d='Error! Data is unavailable.'
	else
		sizeL1d=$(echo "$lscpuOutput" | grep 'L1d ' | awk '{print $3}')
	fi
#-----------------------------------------------------------------------------------------------
#Cmd to get the size of L1i.
#lscpu command used with class to display cpu information
#grep is used to get L1i, while awk is used to print the 2nd itme field
#-z test command is used to check if the data is available or not by testing the variable and checking if it's empty or not. If empty an error is displayed
	sizeL1i=$(echo "$lscpuOutput" | grep 'L1i ' | awk '{print $3}')
	if [ -z "$sizeL1i" ]; then 
		sizeL1i='Error! Data is unavailable.'
	else
		sizeL1i=$(echo "$lscpuOutput" | grep 'L1i ' | awk '{print $3}')
	fi
#-----------------------------------------------------------------------------------------------
#Cmd to get the size of L2.
#lscpu command used  to display cpu information
#grep is used to get L2, while awk is used to print the 2nd itme field
#-z test command is used to check if the data is available or not by testing the variable and checking if it's empty or not. If empty an error is displayed
	sizeL2=$(echo "$lscpuOutput" | grep 'L2' | awk '{print $3}')
	if [ -z "$sizeL2" ]; then 
		sizeL2='Error! Data is unavailable.'
	else
		sizeL2=$(echo "$lscpuOutput" | grep 'L2 ' | awk '{print $3}')
	fi
#-----------------------------------------------------------------------------------------------
#Cmd to get the size of L3.
#lscpu command used with class "system" to display cpu information
#grep is used to get L3, while awk is used to print the 2nd itme field
#-z test command is used to check if the data is available or not by testing the variable and checking if it's empty or not. If empty an error is displayed
	sizeL3=$(echo "$lscpuOutput" | grep 'L3' | awk '{print $3}')
	if [ -z "$sizeL3" ]; then 
		sizeL3='Error! Data is unavailable.'
	else
		sizeL3=$(echo "$lscpuOutput" | grep 'L3 ' | awk '{print $3}')
	fi

#Commands to print the CPU information.	
cat <<EOF
	
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

#Create a function for network report
function networkreport() {
#Display Interface model or description
	interfaceDescription=$(lshw -C network | grep -i 'description:' | awk '{print $1, $2, $3}')
	if [ -z "$interfaceDescription" ]; then 
		interfaceDescription='Error! Data is unavailable.'
	else
		interfaceDescription=$(lshw -C network | grep -i 'description:' | awk '{print $1, $2, $3}')
	fi
#---------------------------------------------------------------------------------------------------------------
#Display Interface manufacturer
#lshw command used with interface menu to filter hardware information
#grep is used to get vendor, while awk is used to print the 2nd itme field
#-z test command is used to check if the data is available or not by testing the variable and checking if it's empty or not. If empty an error is displayed
	interfaceManu=$(lshw -C network | grep -i 'vendor:' | awk '{print $2, $3}')
	if [ -z "$interfaceManu" ]; then 
		interfaceManu='Error! Data is unavailable.'
	else
		interfaceManu=$(lshw -C network | grep -i 'vendor:' | awk '{print $2, $3}')
	fi
#-------------------------------------------------------------------------------------------------------------
#Display Interface speed
#grep is used to get speed, while awk is used to print the 2nd itme field
#-z test command is used to check if the data is available or not by testing the variable and checking if it's empty or not. If empty an error is displayed
	interSpeed=$(ethtool ens33 | grep 'Speed:' | awk '{print $2}')
	if [ -z "$interSpeed" ]; then 
		interSpeed='Error! Data is unavailable.'
	else
		interSpeed=$(ethtool ens33 | grep 'Speed:' | awk '{print $2}')
	fi
#-------------------------------------------------------------------------------------------------------------
#Display interface Ip Address
#awk is used to print the 2nd itme field
#-z test command is used to check if the data is available or not by testing the variable and checking if it's empty or not. If empty an error is displayed
	interIpAdd=$(ip -4 addr show | awk '/inet /{print $2}')
	if [ -z "$interIpAdd" ]; then 
		interIpAdd='Error! Data is unavailable.'
	else
		interIpAdd=$(ip -4 addr show | awk '/inet /{print $2}')
	fi
#-------------------------------------------------------------------------------------------------------------
#Display interface bridge master 
#awk is used to print the 2nd itme field
#-z test command is used to check if the data is available or not by testing the variable and checking if it's empty or not. If empty an error is displayed
	interBridgeMaster=$(sudo brctl show | awk 'NR > 1 {print $1, $4}')
	if [ -z "$interBridgeMaster" ]; then 
		interBridgeMaster='N/A'
	else
		interBridgeMaster=$(sudo brctl show | awk 'NR > 1 {print $1, $4}')
	fi
#-------------------------------------------------------------------------------------------------------------

#Display DNS server
#grep is used to get name server, while awk is used to print the 2nd itme field
#-z test command is used to check if the data is available or not by testing the variable and checking if it's empty or not. If empty an error is displayed
	DNSserver=$(cat /etc/resolv.conf | grep "nameserver" | awk '{print $2}')
	if [ -z "$DNSserver" ]; then 
		DNSserver='N/A'
	else
		DNSserver=$(cat /etc/resolv.conf | grep "nameserver" | awk '{print $2}')
	fi
#------------------------------------------------------------------------------------------------------------

#Display search domain
#grep is used to get search, while awk is used to print the 2nd itme field
#-z test command is used to check if the data is available or not by testing the variable and checking if it's empty or not. If empty an error is displayed
	searchDomain=$(cat /etc/resolv.conf | grep "search" | awk 'NR == 2 {print $2}')
	if [ -z "$searchDomain" ]; then 
		searchDomain='Error! Data is unavailable.'
	else
		searchDomain=$(cat /etc/resolv.conf | grep "search" | awk 'NR == 2 {print $2}')
	fi
#------------------------------------------------------------------------------------------------------------
#Display table of the installed installed network interfaces (including virtual devices) with each table row
	interfaceTable=$(paste -d ';' <(echo "$interfaceDescription") <(echo "$interfaceManu") <(echo "$interSpeed") <(echo "$interIpAdd") <(echo "$interBridgeMaster") <(echo "$DNSserver") <(echo "$searchDomain") | column -N 'Interface description',Manufacturer,'Interface Speed','Ip Address','Bridge Master','DNS Server','Search Domain' -s ';' -o ' | ' -t)
 #Display network information	
cat <<-EOF

========================================================================================================
-NETWORK INFORMATION-
$interfaceTable
EOF
	
}

########################################################## Storage Information ##############################################################
#Create a function to print the disk report.
function diskreport() {
#Display drive Manufacturer
#lshw command used with drive manufacturer to filter hardware information
#grep is used to get -A10, while awk is used to print the 2nd itme field
#-z test command is used to check if the data is available or not by testing the variable and checking if it's empty or not. If empty an error is displayed
	driveManufacturer0=$(echo "$lshwOutput" | grep -A10 '\*\-disk' | grep 'vendor:' | awk '{$1=""; print $0}')
	if [ -z "$driveManufacturer0" ]; then 
		driveManufacturer0='Error! Data is unavailable.'
	else
		driveManufacturer0=$(echo "$lshwOutput" | grep -A10 '\*\-disk' | grep 'vendor:' | awk '{$1=""; print $0}')
	fi
#---------------------------------------------------------------------------------------------------------

#Display drive vendor 1
#lshw command used with drive vendor to filter hardware information
#grep is used to get -m1 -A8, while awk is used to print the 2nd itme field
#-z test command is used to check if the data is available or not by testing the variable and checking if it's empty or not. If empty an error is displayed
	drivevendor1=$(echo "$lshwOutput" | grep -m1 -A8 "\-volume:0" | grep 'vendor:' | awk '{$1=""; print $0}')
	if [ -z "$drivevendor1" ]; then 
		drivevendor1='Error! Data is unavailable.'
	else
		drivevendor1=$(echo "$lshwOutput" | grep -m1 -A8 "\-volume:0" | grep 'vendor:' | awk '{$1=""; print $0}')
	fi
#-----------------------------------------------------------------------------------------------------------
#Display drive vendor 2
#lshw command used with drive vendor to filter hardware information
#grep is used to get vendor, while awk is used to print the 2nd itme field
#-z test command is used to check if the data is available or not by testing the variable and checking if it's empty or not. If empty an error is displayed
	drivevendor2=$(echo "$lshwOutput" | grep -m1 -A8 "\-volume:1" | grep 'vendor:' | awk '{$1=""; print $0}')
	if [ -z "$drivevendor1" ]; then 
		drivevendor2='Error! Data is unavailable.'
	else
		drivevendor2=$(echo "$lshwOutput" | grep -m1 -A8 "\-volume:1" | grep 'vendor:' | awk '{$1=""; print $0}')
	fi
#-----------------------------------------------------------------------------------------------------------
#Display drive vendor 3
#lshw command used with drive vendor to filter hardware information
#grep is used to get -m1 -A8, while awk is used to print the 2nd itme field
#-z test command is used to check if the data is available or not by testing the variable and checking if it's empty or not. If empty an error is displayed
	drivevendor3=$(echo "$lshwOutput" | grep -m1 -A8 "\-volume:2" | grep 'vendor:' | awk '{$1=""; print $0}')
	if [ -z "$drivevendor3" ]; then 
		drivevendor3='Error! Data is unavailable.'
	else
		drivevendor3=$(echo "$lshwOutput" | grep -m1 -A8 "\-volume:2" | grep 'vendor:' | awk '{$1=""; print $0}')
	fi
#-----------------------------------------------------------------------------------------------------------
#Display drive model
#lshw command used with drive model to filter hardware information
#grep is used to -m1 -A10, while awk is used to print the 2nd itme field
#-z test command is used to check if the data is available or not by testing the variable and checking if it's empty or not. If empty an error is displayed
	driveModel=$(echo "$lshwOutput" | grep -m1 -A10 "\-disk" | grep 'product:' | awk '{$1=""; print $0}')
	if [ -z "$driveModel" ]; then 
		driveModel='Error! Data is unavailable.'
	else
		driveModel=$(echo "$lshwOutput" | grep -m1 -A10 "\-disk" | grep 'product:' | awk '{$1=""; print $0}')
	fi
#-----------------------------------------------------------------------------------------------------------

#Display drive size.
#lshw command used with driveSize0 to filter hardware information
#grep is used to get sda, while awk is used to print the 2nd itme field
#-z test command is used to check if the data is available or not by testing the variable and checking if it's empty or not. If empty an error is displayed
	driveSize0=$(echo "$lsblkOutput" | grep "sda" | awk 'FNR==1 {print $4"B"}')
	if [ -z "$driveSize0" ]; then 
		driveSize0='Error! Data is unavailable.'
	else
		driveSize0=$(echo "$lsblkOutput" | grep "sda" | awk 'FNR==1 {print $4"B"}')
	fi
#------------------------------------------------------------------------------------------------------------
#Display drive size 1.
#grep is used to get sda, while awk is used to print the 2nd itme field
#-z test command is used to check if the data is available or not by testing the variable and checking if it's empty or not. If empty an error is displayed
	driveSize1=$(echo "$lsblkOutput" | grep "sda" | awk 'FNR==2 {print $4"B"}')
	if [ -z "$driveSize1" ]; then 
		driveSize1='Error! Data is unavailable.'
	else
		driveSize1=$(echo "$lsblkOutput" | grep "sda" | awk 'FNR==2 {print $4"B"}')
	fi
#-----------------------------------------------------------------------------------------------------------

#Display drive size 2
#grep is used to get sda, while awk is used to print the 2nd itme field
#-z test command is used to check if the data is available or not by testing the variable and checking if it's empty or not. If empty an error is displayed
	driveSize2=$(echo "$lsblkOutput" | grep "sda" | awk 'FNR==3 {print $4"B"}')
	if [ -z "$driveSize2" ]; then 
		driveSize2='Error! Data is unavailable.'
	else
		driveSize2=$(echo "$lsblkOutput" | grep "sda" | awk 'FNR==3 {print $4"B"}')
	fi
#----------------------------------------------------------------------------------------------------------

#Display drive size 3
#grep is used to get sda, while awk is used to print the 2nd itme field
#-z test command is used to check if the data is available or not by testing the variable and checking if it's empty or not. If empty an error is displayed
	driveSize3=$(echo "$lsblkOutput" | grep "sda" | awk 'FNR==4 {print $4"B"}')
	if [ -z "$driveSize3" ]; then 
		driveSize3='Error! Data is unavailable.'
	else
		driveSize3=$(echo "$lsblkOutput" | grep "sda" | awk 'FNR==4 {print $4"B"}')
	fi
#----------------------------------------------------------------------------------------------------------

#Display drive partition 0
#grep is used to get sda, while awk is used to print the 2nd itme field
#-z test command is used to check if the data is available or not by testing the variable and checking if it's empty or not. If empty an error is displayed
	drivePartition0=$(echo "$lsblkOutput" | grep "sda" | awk 'FNR==1 {print $1}')
	if [ -z "$drivePartition0" ]; then 
		drivePartition0='Error! Data is unavailable.'
	else
		drivePartition0=$(echo "$lsblkOutput" | grep "sda" | awk 'FNR==1 {print $1}')
	fi
#---------------------------------------------------------------------------------------------------------
#Display drive partition 1
#grep is used to get sda1, while awk is used to print the 2nd itme field
#-z test command is used to check if the data is available or not by testing the variable and checking if it's empty or not. If empty an error is displayed
	drivePartition1=$(echo "$lsblkOutput" | grep "sda1" | awk 'FNR==1 {print $1}' | tail -c 5)
	if [ -z "$drivePartition1" ]; then 
		drivePartition1='Error! Data is unavailable.'
	else
		drivePartition1=$(echo "$lsblkOutput" | grep "sda1" | awk 'FNR==1 {print $1}' | tail -c 5)
	fi
#-------------------------------------------------------------------------------------------------------
#Display drive partition 2
#grep is used to get sda2, while awk is used to print the 2nd itme field
#-z test command is used to check if the data is available or not by testing the variable and checking if it's empty or not. If empty an error is displayed
	drivePartition2=$(echo "$lsblkOutput" | grep "sda2" | awk 'FNR==1 {print $1}' | tail -c 5)
	if [ -z "$drivePartition2" ]; then 
		drivePartition2='Error! Data is unavailable.'
	else
		drivePartition2=$(echo "$lsblkOutput" | grep "sda2" | awk 'FNR==1 {print $1}' | tail -c 5)
	fi
#----------------------------------------------------------------------------------------------------------

#Display drive partition 3
#grep is used to get sda3, while awk is used to print the 2nd itme field
#-z test command is used to check if the data is available or not by testing the variable and checking if it's empty or not. If empty an error is displayed
	drivePartition3=$(echo "$lsblkOutput" | grep "sda3" | awk 'FNR==1 {print $1}' | tail -c 5)
	if [ -z "$drivePartition3" ]; then 
		drivePartition3='Error! Data is unavailable.'
	else
	drivePartition3=$(echo "$lsblkOutput" | grep "sda3" | awk 'FNR==1 {print $1}' | tail -c 5)
	fi
#---------------------------------------------------------------------------------------------------------

#Display drive mount point 0.
#grep is used to get sda, while awk is used to print the 2nd itme field
#-z test command is used to check if the data is available or not by testing the variable and checking if it's empty or not. If empty an error is displayed
	driveMountPoint0=$(echo "$lsblkOutput" | grep "sda" | awk 'FNR==1 {print $7}')
	if [ -z "$driveMountPoint0" ]; then 
		driveMountPoint0='Error! Data is unavailable.'
	else
		driveMountPoint0=$(echo "$lsblkOutput" | grep "sda" | awk 'FNR==1 {print $7}')
	fi
#--------------------------------------------------------------------------------------------------------

#Display drive mount point 1.
#grep is used to get sda, while awk is used to print the 2nd itme field
#-z test command is used to check if the data is available or not by testing the variable and checking if it's empty or not. If empty an error is displayed
	driveMountPoint1=$(echo "$lsblkOutput" | grep "sda" | awk 'FNR==2 {print $7}')
	if [ -z "$driveMountPoint1" ]; then 
		driveMountPoint1='Error! Data is unavailable.'
	else
		driveMountPoint1=$(echo "$lsblkOutput" | grep "sda" | awk 'FNR==2 {print $7}')
	fi

#Display drive mount point 2.
#grep is used to get sda, while awk is used to print the 2nd itme field
#-z test command is used to check if the data is available or not by testing the variable and checking if it's empty or not. If empty an error is displayedd
	driveMountPoint2=$(echo "$lsblkOutput" | grep "sda" | awk 'FNR==3 {print $7}')
	if [ -z "$driveMountPoint2" ]; then 
		driveMountPoint2='Error! Data is unavailable.'
	else
		driveMountPoint2=$(echo "$lsblkOutput" | grep "sda" | awk 'FNR==3 {print $7}')
	fi
#-----------------------------------------------------------------------------------------------------

#Display drive mount point 3.
#grep is used to get sda, while awk is used to print the 2nd itme field
#-z test command is used to check if the data is available or not by testing the variable and checking if it's empty or not. If empty an error is displayed
	driveMountPoint3=$(echo "$lsblkOutput" | grep "sda" | awk 'FNR==4 {print $7}')
	if [ -z "$driveMountPoint3" ]; then 
		driveMountPoint3='Error! Data is unavailable.'
	else
		driveMountPoint3=$(echo "$lsblkOutput" | grep "sda" | awk 'FNR==4 {print $7}')
	fi
#-----------------------------------------------------------------------------------------------------
#Display drive File system SizeSDA2
#grep is used to get sda, while awk is used to print the 2nd itme field
#-z test command is used to check if the data is available or not by testing the variable and checking if it's empty or not. If empty an error is displayed
	driveFilesystemSizeSDA2=$(echo "$lsblkOutput" | grep "sda2" | awk '{print $2"B"}')
	if [ -z "$driveFilesystemSizeSDA2" ]; then 
		driveFilesystemSizeSDA2='Error! Data is unavailable.'
	else
		driveFilesystemSizeSDA2=$(echo "$lsblkOutput" | grep "sda2" | awk '{print $2"B"}')
	fi
#----------------------------------------------------------------------------------------------------

#Display drive File system SizeSDA3
#grep is used to get sda3, while awk is used to print the 2nd itme field
#-z test command is used to check if the data is available or not by testing the variable and checking if it's empty or not. If empty an error is displayed
	driveFilesystemSizeSDA3=$(echo "$lsblkOutput" | grep "sda3" | awk '{print $2"B"}')
	if [ -z "$driveFilesystemSizeSDA3" ]; then 
		driveFilesystemSizeSDA3='Error! Data is unavailable.'
	else
		driveFilesystemSizeSDA3=$(echo "$lsblkOutput" | grep "sda3" | awk '{print $2"B"}')
	fi
#----------------------------------------------------------------------------------------------------

#Display drive File system free SDA2
	driveFilesystemFreeSDA2=$(echo "$lsblkOutput" | grep "sda2" | awk '{print $4"B"}')
	if [ -z "$driveFilesystemFreeSDA2" ]; then 
		driveFilesystemFreeSDA2='Error! Data is unavailable.'
	else
		driveFilesystemFreeSDA2=$(echo "$lsblkOutput" | grep "sda2" | awk '{print $4"B"}')
	fi
#------------------------------------------------------------------------------------------------------

#Display drive File system free SDA3
#grep is used to get sda3, while awk is used to print the 2nd itme field
#-z test command is used to check if the data is available or not by testing the variable and checking if it's empty or not. If empty an error is displayed
	driveFilesystemFreeSDA3=$(echo "$lsblkOutput" | grep "sda3" | awk '{print $4"B"}')
	if [ -z "$driveFilesystemFreeSDA3" ]; then 
		driveFilesystemFreeSDA3='Error! Data is unavailable.'
	else
		driveFilesystemFreeSDA3=$(echo "$lsblkOutput" | grep "sda3" | awk '{print $4"B"}')
	fi
#-----------------------------------------------------------------------------------------------------

#Command to display the disk information in the table form.
	diskTable=$(paste -d ';' <(echo "$drivePartition0" ; echo "$drivePartition1" ; echo "$drivePartition2" ; echo "$drivePartition3") <(echo "$driveManufacturer0" ; echo "$drivevendor1" ; echo "$drivevendor2" ; echo "$drivevendor3") <(echo "$driveModel" ; echo "N/A" ; echo "N/A" ; echo "N/A") <(echo "$driveSize0" ; echo "$driveSize1" ; echo "$driveSize2" ; echo "$driveSize3") <(echo "N/A" ; echo "N/A" ; echo "$driveFilesystemSizeSDA2" ; echo "$driveFilesystemSizeSDA3") <(echo "N/A" ; echo "N/A" ; echo "$driveFilesystemFreeSDA2" ; echo "$driveFilesystemFreeSDA3") <(echo "$driveMountPoint0" ; echo "$driveMountPoint1" ; echo "$driveMountPoint2" ; echo "$driveMountPoint3") | column -N 'Partition Name (/dev/sda)',Vendor,Model,Size,'Filesystem Size','Filesystem Free Space','Mount Point' -s ';' -o ' | ' -t) 

#Command to print the disk information	
cat <<EOF

========================================================================================================
-DISK INFORMATION-

$diskTable
EOF
	}
	
####################### RAM INFORMATION ##############################

#Create a function to get the components of RAM
function ramreport() {
#Cmd to get Ram Manufacturer
	ramManufacturer=$(echo "$dmidecodeOutput" | grep -m1 -i "manufacturer" | awk '{$1=""; print $0}')
	if [ -z "$ramManufacturer" ]; then 
		ramManufacturer='Error! Data is unavailable.'
	else
		ramManufacturer=$(echo "$dmidecodeOutput" | grep -m1 -i "manufacturer" | awk '{$1=""; print $0}')
	fi
#-------------------------------------------------------------------------------------------------------------
#Cmd to get Ram name
#lshw command used with ram product name to filter hardware system
#grep is used to get model name, while awk is used to print the 2nd itme field
#-z test command is used to check if the data is available or not by testing the variable and checking if it's empty or not. If empty an error is displayed

	ramProductName=$(echo "$dmidecodeOutput" | grep -m1 -i "Product name" | awk '{$1=""; $2=""; print $0}')
	if [ -z "$ramProductName" ]; then 
		ramProductName='Error! Data is unavailable.'
	else
		ramProductName=$(echo "$dmidecodeOutput" | grep -m1 -i "Product name" | awk '{$1=""; $2=""; print $0}')
	fi
#-------------------------------------------------------------------------------------------------------------
#Cmd to get Ram serial number
#lshw command used with ram serial number to filter hardware system
#grep is used to get -m,file is used to print the 2nd itme field
#-z test command is used to check if the data is available or not by testing the variable and checking if it's empty or not. If empty an error is displayed
	ramSerialNum=$(echo "$dmidecodeOutput" | grep -m1 -i "serial number" | awk '{$1=""; print $0}')
	if [ -z "$ramSerialNum" ]; then 
		ramSerialNum='Error! Data is unavailable.'
	else
		ramSerialNum=$(echo "$dmidecodeOutput" | grep -m1 -i "serial number" | awk '{$1=""; print $0}')
	fi
#------------------------------------------------------------------------------------------------------------------
#Cmd to get Ram Size
#lshw command used with ram size to filter system hardware
#grep is used to get model name, while awk is used to print the 2nd itme field
#-z test command is used to check if the data is available or not by testing the variable and checking if it's empty or not. If empty an error is displayed
	ramSize=$(echo "$lshwOutput" | grep -A10 "\-memory" | grep 'size:' | awk 'FNR == 2 {$1=""; print $0}')
	if [ -z "$ramSize" ]; then 
		ramSize='Error! Data is unavailable.'
	else
		ramSize=$(echo "$lshwOutput" | grep -A10 "\-memory" | grep 'size:' | awk 'FNR == 2 {$1=""; print $0}')
	fi
#--------------------------------------------------------------------------------------------------------------------
#Cmd to get Ram Speed
#lshw command used with ram speed to filter system hardware
#grep is used to get model name, while awk is used to print the 2nd itme field
#-z test command is used to check if the data is available or not by testing the variable and checking if it's empty or not. If empty an error is displayed
	ramSpeed=$(echo "$dmidecodeOutput" --type 17 | grep -m1 Speed | awk '{$1=""; print $0}')
	if [ -z "$ramSpeed" ]; then 
		ramSpeed='Error! Data is unavailable.'
	else
		ramSpeed=$(echo "$dmidecodeOutput" --type 17 | grep -m1 Speed | awk '{$1=""; print $0}')
	fi
#--------------------------------------------------------------------------------------------------------------------

#Cmd to get Ram Location
#lshw command used with ram location to filter hardware system
#grep is used to get model name, while awk is used to print the 2nd itme field
#-z test command is used to check if the data is available or not by testing the variable and checking if it's empty or not. If empty an error is displayed
	ramLocation=$(echo "$lshwOutput" | grep -m1 'slot: RAM' |awk '{$1=""; $2=""; print $0}')
	if [ -z "$ramLocation" ]; then 
		ramLocation='Error! Data is unavailable.'
	else
		ramLocation=$(echo "$lshwOutput" | grep -m1 'slot: RAM' |awk '{$1=""; $2=""; print $0}')
	fi
#--------------------------------------------------------------------------------------------------------------------

#Cmd to get Ram total size.
#lshw command used with total size system hardware
#grep is used to get memory,awk is used to print the 2nd itme field
#-z test command is used to check if the data is available or not by testing the variable and checking if it's empty or not. If empty an error is displayed
	totalSize=$(echo "$lshwOutput" | grep -A5 "\-memory" | grep -m1 'size:' | awk '{$1=""; print $0}')
	if [ -z "$totalSize" ]; then 
		totalSize='Error! Data is unavailable.'
	else
		totalSize=$(echo "$lshwOutput" | grep -A5 "\-memory" | grep -m1 'size:' | awk '{$1=""; print $0}')
	fi
#------------------------------------------------------------------------------------------------------------------
#Command to display the RAM information in the table form.
	ramTable=$(paste -d ';' <(echo "$ramManufacturer") <(echo "$ramProductName") <(echo "$ramSerialNum") <(echo "$ramSize") <(echo "$ramSpeed") <(echo "$ramLocation") <(echo "$totalSize") | column -N Manufacturer,Model,'Seial Number',Size,Speed,Location,'Total size' -s ';' -o ' | ' -t)	

#display the table
cat <<EOF

========================================================================================================
-RAM INFORMATION-
$ramTable
EOF
}


####################### Video Report ##############################
#Create a video report function.
function videoreport() {

#Cmd to get Video manufacturer.
#lshw command used with class display to filter hardware information
#grep is used to get model name, while awk is used to print the 2nd itme field
#-z test command is used to check if the data is available or not by testing the variable and checking if it's empty or not. If empty an error is displayed
	videoManu=$(lshw -class display | grep "vendor:" | awk '{print $2}')
	if [ -z "$videoManu" ]; then 
		videoManu='Error! Data is unavailable.'
	else
		videoManu=$(lshw -class display | grep "vendor:" | awk '{print $2}')
	fi
#-----------------------------------------------------------------------------------------------------------
#Cmd to get Video description.
#lshw command used with -C display to filter system hardware
#grep is used to get description, while awk is used to print the 2nd itme field
#-z test command is used to check if the data is available or not by testing the variable and checking if it's empty or not. If empty an error is displayed
	videoDescription=$(lshw -C display | grep 'description:' | awk '{$1=""; print $0}')
	if [ -z "$videoDescription" ]; then 
		videoDescription='Error! Data is unavailable.'
	else
		videoDescription=$(lshw -C display | grep 'description:' | awk '{$1=""; print $0}')
	fi
#--------------------------------------------------------------------------------------------------------

#Display the imnformation got by the videoreport function.	
cat <<EOF

========================================================================================================
-VIDEO INFORMATION-
Manufacturer=$videoManu
Description=$videoDescription
EOF
	
	}
	
	
############################################## COMPUTER INFORMATION ################################################

#Create a function for Computer information.
function computerreport() {
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
#Display the system information.
cat <<EOF

========================================================================================================
-SYSTEM DESCRIPTION-

Computer manufacturer=         $cmpmanuftr
Computer description or model=  $cmpdescription
Computer serial number=        $cmpserial
EOF
	
}	

####################################### OS INFORMATION ################################################

function osreport() {
	#Cmd to get Os distro version.
	distroversion=$(hostnamectl | grep 'Kernel: ' | awk '{$1=""; print $0}')
	if [ -z "$cmpdescription" ]; then 
		distroversion='Error! Data is unavailable.'
	else
		distroversion=$(hostnamectl | grep 'Kernel: ' | awk '{$1=""; print $0}')
	fi

	#Heading and command for The operating system name and version
	Host_Information=$(hostnamectl | awk 'FNR == 7 {print $3, $4, $5}')
	
#Display the OS information.
cat <<EOF

========================================================================================================
-OS INFOPRMATION-

Linux distro=                  $Host_Information
Distro version=               $distroversion
EOF
	
}

#This function displays help information if the user asks for it on the command line or gives us a bad command line
function displayhelp {
cat <<EOF 
  Usage: sysconfig [OPTION]...
  [OPTIONS]       [DESCRIPTION]
  --help:         Displays Help Information\n
  --disk:         Displays Disk Information\n
  --network:      Runs only the network report\n
  --system:       runs only the computerreport, osreport, cpureport, ramreport, and videoreport
  --verbose:      runs your script verbosely, showing any errors to the user instead of sending them to the logfile
EOF
}

#Create a function for the error message which saves the error message with a timestamp into a logfile named /var/log/systeminfo.log.
function errormessage() {
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    local error_message="$1"
    echo "[$timestamp] $error_message" >> /var/log/systeminfo.log
    if [[ "$verbose" == true ]]; then 
    echo "Error has occured at [$timestamp] for invalid option: $error_message ; Refer to help section (sysinfo.sh -h)"
    fi
    
}

