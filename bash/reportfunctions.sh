#Define the variables for lsblk, dmidecode, lshw, lscpu

lscpuOutput=$(lscpu)

lsblkOutput=$(lsblk)

lshwOutput=$(lshw)

dmidecodeOutput=$(dmidecode)

#-------------------------------CPU INFORMATION BLOCK----------------------------------#

function cpureport()  {

#Cmd to get the cpu manufacturer.

#lshw command used with model name to filter system hardware

#grep is used to get model name, while awk is used to print the 2nd itme field

#-z test command is used to check if the data is available or not by testing the variable and checking if it's empty or not. If empty an error is displayed


	cpuManufacturer=$(echo "$lshwOutput" | grep 'Model name:' | sed 's/,"Model name: *//') 
	if [ -z "$cpuManufacturer" ]; then 
		cpuManufacturer = "Error! Data is unavailable."
		
	else
		cpuManufacturer=$(echo "$lscpuOutput" | grep 'Model name:' | sed 's/,"Model name: *//')
		
	fi
	


#Cmd to get the Cpu maximum speed.

#lshw command used with class "CPU" to display cpu information


	cpuMaxSpeed=$(echo "$lshwOutput" -class cpu | grep 'capacity: ' | head -1 | awk '{print$2}')
	
	#Adding the block that display error message if the information is not available.
	if [ -z "$cpuMaxSpeed " ]; then 
		cpuMaxSpeed="Error! Data is unavailable."
		
	else
		cpuMaxSpeed=$(echo "$lshwOutput" -class cpu | grep 'capacity: ' | head -1 | awk '{print$2}')
		
	fi
	



#Cmd to get the Cpu core count.

#lscpu command used with class "system" to display cpu information

#grep is used to get CPU, while awk is used to print the 2nd itme field

	cpuCore=$(echo "$lscpuOutput" | grep 'CPU(s): ' | head -1 | awk '{print$2}')
	
	#Adding the block that display error message if the information is not available.
	
	if [ -z "$cpucore" ]; then 
		cpuCore='Error! Data is unavailable.'
		
	else
		cpuCore=$(echo "$lscpuOutput" | grep 'CPU(s): ' | head -1 | awk '{print$2}')
		
	fi
	



#Cmd to get the architecture of CPU.

#lscpu command used to display cpu information

#grep is used to get architecture, while awk is used to print the 2nd itme field

#-z test command is used to check if the data is available or not by testing the variable and checking if it's empty or not. If empty an error is displayed

	cpuArchitecture=$(echo "$lscpuOutput" | grep 'Architecture: ' | awk '{print$2}')
	
	#Adding the block that display error message if the information is not available.
	if [ -z "$cpuArchitecture" ]; then 
		cpuArchitecture = 'Error! Data is unavailable.'
		
	else
		cpuArchitecture = $(echo "$lscpuOutput" | grep 'Architecture: ' | awk '{print$2}')
		
	fi
	


#Cmd to get the size of L1d.

#lscpu command used with class "system" to display cpu information


	sizeL1d=$(echo "$lscpuOutput" | grep 'L1d ' | awk '{print $3}')
	
	#Adding the block that display error message if the information is not available.
	if [ -z "$sizeL1d" ]; then 
		sizeL1d='Error! Data is unavailable.'
		
	else
		sizeL1d=$(echo "$lscpuOutput" | grep 'L1d ' | awk '{print $3}')
		
	fi
	


#Cmd to get the size of L1i.

#lscpu command used with class to display cpu information


	sizeL1i=$(echo "$lscpuOutput" | grep 'L1i ' | awk '{print $3}')
	
	#Adding the block that display error message if the information is not available.
	if [ -z "$sizeL1i" ]; then 
		sizeL1i='Error! Data is unavailable.'
		
	else
		sizeL1i=$(echo "$lscpuOutput" | grep 'L1i ' | awk '{print $3}')
		
	fi
	


#Cmd to get the size of L2.

#lscpu command used  to display cpu information


	sizeL2=$(echo "$lscpuOutput" | grep 'L2' | awk '{print $3}')
	
	#Adding the block that display error message if the information is not available.
	if [ -z "$sizeL2" ]; then 
		sizeL2="Error! Data is unavailable."
		
	else
		sizeL2=$(echo "$lscpuOutput" | grep 'L2 ' | awk '{print $3}')
	fi
	


#Cmd to get the size of L3.

#lscpu command used with class "system" to display cpu information


	sizeL3=$(echo "$lscpuOutput" | grep 'L3' | awk '{print $3}')
	
	#Adding the block that display error message if the information is not available.
	if [ -z "$sizeL3" ]; then 
		sizeL3="Error! Data is unavailable."
		
	else
		sizeL3=$(echo "$lscpuOutput" | grep 'L3 ' | awk '{print $3}')
		
	fi

#--------------------------- PRINT CPU INFO ----------------------------#	

#Use the cat command to print the CPU information in a parahgraph block

cat <<EOF

<<<<<<<<<<<<<<<<<<< CPU INFORMATION >>>>>>>>>>>>>>>>>>>>>>

CPU Model & Manufacturer = $cpuManufacturer


CPU Maximum Speed=             $cpuMaxSpeed


CPU Core Count=                $cpuCore


CPU Architecture=              $cpuArchitecture


Size of caches (L1d)=          $sizeL1d


Size of caches (L1i)=          $sizeL1i


Size of caches (L2)=           $sizeL2


Size of caches (L3)=           $sizeL3

EOF

}

#------------------------------------- NETWORK REPORT --------------------------------------#

#Create a function for network report

function networkReport() {

#Display Interface model or description

	interfaceDesc=$(lshw -C network | grep -i 'description:' | awk '{print $1, $2, $3}')
	
	#Adding the block that display error message if the information is not available.
	if [ -z "$interfaceDesc" ]; then 
		interfaceDesc="Error! Data is unavailable."
		
	else
		interfaceDescr=$(lshw -C network | grep -i 'description:' | awk '{print $1, $2, $3}')
		
	fi
	


#Display interface Ip Address


	intIpAddress=$(ip -4 addr show | awk '/inet /{print $2}')
	
	#Adding the block that display error message if the information is not available.
	if [ -z "$intIpAddress" ]; then 
		intIpAddress='Error! Data is unavailable.'
		
	else
		intIpAddress=$(ip -4 addr show | awk '/inet /{print $2}')
		
	fi
	

#Display Interface speed

	intSpeed=$(ethtool ens33 | grep 'Speed:' | awk '{print $2}')
	
	#Adding the block that display error message if the information is not available.
	if [ -z "$intSpeed" ]; then 
		intSpeed="Error! Data is unavailable."
		
	else
		intSpeed=$(ethtool ens33 | grep 'Speed:' | awk '{print $2}')
		
	fi
	
	
#lshw command used with interface menu to filter hardware information

	intManufacturer=$(lshw -C network | grep -i 'vendor:' | awk '{print $2, $3}')
	
	#Adding the block that display error message if the information is not available.
	if [ -z "$intManufacturer" ]; then 
		intManufacturer="Error! Data is unavailable."
		
	else
		intManufacturer=$(lshw -C network | grep -i 'vendor:' | awk '{print $2, $3}')
		
	fi
	



#Display DNS server


	DNSServer=$(cat /etc/resolv.conf | grep "nameserver" | awk '{print $2}')
	
	#Adding the block that display error message if the information is not available.
	if [ -z "$DNSServer" ]; then 
		DNSServer="Error! Data is unavailable."
		
	else
		DNSServer=$(cat /etc/resolv.conf | grep "nameserver" | awk '{print $2}')
		
	fi

#Display interface bridge master 


	intBridgeMaster=$(sudo brctl show | awk 'NR > 1 {print $1, $4}')
	
	#Adding the block that display error message if the information is not available.
	if [ -z "$intBridgeMaster" ]; then 
		intBridgeMaster="Error! Data is unavailable."
		
	else
		intBridgeMaster=$(sudo brctl show | awk 'NR > 1 {print $1, $4}')
		
	fi
	



#Display search domain

	searchDomain=$(cat /etc/resolv.conf | grep "search" | awk 'NR == 2 {print $2}')
	
	#Adding the block that display error message if the information is not available.
	if [ -z "$searchDomain" ]; then 
		searchDomain="Error! Data is unavailable."
		
	else
		searchDomain=$(cat /etc/resolv.conf | grep "search" | awk 'NR == 2 {print $2}')
		
	fi
	

#Display table of the installed network interfaces (including virtual devices) with each table row

	intTable=$(paste -d ';' <(echo "$intDescription")<(echo "$intIpAddress") <(echo "$intSpeed") <(echo "$intManufacturer") <(echo "$DNSServer") <(echo "$intBridgeMaster") <(echo "$searchDomain") | column -N 'Interface description','Ip Address','Interface Speed',Manufacturer,'DNS Server','Bridge Master','Search Domain' -s ';' -o ' | ' -t)
	

  #Display network information as a table by invoking the func.
cat <<-EOF


------------NETWORK INFORMATION---------------
		
 
$intTable


EOF
	
}

#------------------------- STORAGE INFO ------------------------#

#Create a function to print the disk report.

function diskReport() {


#Display drive Manufacturer

#lshw command used with drive manufacturer to filter hardware information


	driveManufacturer=$(echo "$lshwOutput" | grep -A10 '\*\-disk' | grep 'vendor:' | awk '{$1=""; print $0}')
	
	#Adding the block that display error message if the information is not available.
	if [ -z "$driveManufacturer" ]; then 
		driveManufacturer='Error! Data is unavailable.'
		
	else
		driveManufacturer=$(echo "$lshwOutput" | grep -A10 '\*\-disk' | grep 'vendor:' | awk '{$1=""; print $0}')
		
	fi
	
#Display drive model

#lshw command used with drive model to filter hardware information


	driveModel=$(echo "$lshwOutput" | grep -m1 -A10 "\-disk" | grep 'product:' | awk '{$1=""; print $0}')
	
	#Adding the block that display error message if the information is not available.
	if [ -z "$driveModel" ]; then 
		driveModel='Error! Data is unavailable.'
		
	else
		driveModel=$(echo "$lshwOutput" | grep -m1 -A10 "\-disk" | grep 'product:' | awk '{$1=""; print $0}')
		
	fi
	


#Display Drive Vendor 1

#lshw command used with drive vendor to filter hardware information


	driveVendor1=$(echo "$lshwOutput" | grep -m1 -A8 "\-volume:0" | grep 'vendor:' | awk '{$1=""; print $0}')
	
	#Adding the block that display error message if the information is not available.
	if [ -z "$driveVendor1" ]; then 
		driveVendor1="Error! Data is unavailable."
		
	else
		driveVendor1=$(echo "$lshwOutput" | grep -m1 -A8 "\-volume:0" | grep 'vendor:' | awk '{$1=""; print $0}')
		
	fi


#Display drive vendor 2

#lshw command used with drive vendor to filter hardware information


	driveVendor2=$(echo "$lshwOutput" | grep -m1 -A8 "\-volume:1" | grep 'vendor:' | awk '{$1=""; print $0}')
	
	#Adding the block that display error message if the information is not available.
	if [ -z "$driveVendor1" ]; then 
		driveVendor2='Error! Data is unavailable.'
		
	else
		driveVendor2=$(echo "$lshwOutput" | grep -m1 -A8 "\-volume:1" | grep 'vendor:' | awk '{$1=""; print $0}')
		
	fi
	

#Display drive vendor 3


	driveVendor3=$(echo "$lshwOutput" | grep -m1 -A8 "\-volume:2" | grep 'vendor:' | awk '{$1=""; print $0}')
	
	#Adding the block that display error message if the information is not available.
	if [ -z "$drivevendor3" ]; then 
		drivevendor3='Error! Data is unavailable.'
		
	else
		drivevendor3=$(echo "$lshwOutput" | grep -m1 -A8 "\-volume:2" | grep 'vendor:' | awk '{$1=""; print $0}')
		
	fi
	



#Display drive size.

#lshw command used with driveSize0 to filter hardware information


	driveSize0=$(echo "$lsblkOutput" | grep "sda" | awk 'FNR==1 {print $4"B"}')
	
	#Adding the block that display error message if the information is not available.
	if [ -z "$driveSize0" ]; then 
		driveSize0='Error! Data is unavailable.'
		
	else
		driveSize0=$(echo "$lsblkOutput" | grep "sda" | awk 'FNR==1 {print $4"B"}')
		
	fi
	

#Display Drive Size 1.

	driveSize1=$(echo "$lsblkOutput" | grep "sda" | awk 'FNR==2 {print $4"B"}')
	
	#Adding the block that display error message if the information is not available.
	if [ -z "$driveSize1" ]; then 
		driveSize1='Error! Data is unavailable.'
		
	else
		driveSize1=$(echo "$lsblkOutput" | grep "sda" | awk 'FNR==2 {print $4"B"}')
		
	fi


#Display Drive Size 2


	driveSize2=$(echo "$lsblkOutput" | grep "sda" | awk 'FNR==3 {print $4"B"}')
	
	#Adding the block that display error message if the information is not available.
	if [ -z "$driveSize2" ]; then 
		driveSize2='Error! Data is unavailable.'
		
	else
		driveSize2=$(echo "$lsblkOutput" | grep "sda" | awk 'FNR==3 {print $4"B"}')
		
	fi


#Display Drive Size 3


	driveSize3=$(echo "$lsblkOutput" | grep "sda" | awk 'FNR==4 {print $4"B"}')
	
	#Adding the block that display error message if the information is not available.
	if [ -z "$driveSize3" ]; then 
		driveSize3='Error! Data is unavailable.'
		
	else
		driveSize3=$(echo "$lsblkOutput" | grep "sda" | awk 'FNR==4 {print $4"B"}')
		
	fi



#Display drive File system SizeSDA2



	driveFileSystemSizeSDA2=$(echo "$lsblkOutput" | grep "sda2" | awk '{print $2"B"}')
	
	#Adding the block that display error message if the information is not available.
	if [ -z "$driveFileSystemSizeSDA2" ]; then 
		driveFileSystemSizeSDA2='Error! Data is unavailable.'
		
	else
		driveFileSystemSizeSDA2=$(echo "$lsblkOutput" | grep "sda2" | awk '{print $2"B"}')
		
	fi


#Display drive File system SizeSDA3


	driveFileSystemSizeSDA3=$(echo "$lsblkOutput" | grep "sda3" | awk '{print $2"B"}')
	
	#Adding the block that display error message if the information is not available.
	if [ -z "$driveFileSystemSizeSDA3" ]; then 
		driveFilesyStemSizeSDA3='Error! Data is unavailable.'
		
	else
		driveFileSystemSizeSDA3=$(echo "$lsblkOutput" | grep "sda3" | awk '{print $2"B"}')
		
	fi


#Display drive File system free SDA2


	driveFileSystemFreeSDA2=$(echo "$lsblkOutput" | grep "sda2" | awk '{print $4"B"}')
	
	#Adding the block that display error message if the information is not available.
	if [ -z "$driveFileSystemFreeSDA2" ]; then 
		driveFilesystemFreeSDA2='Error! Data is unavailable.'
		
	else
		driveFileSystemFreeSDA2=$(echo "$lsblkOutput" | grep "sda2" | awk '{print $4"B"}')
	fi


#Display drive File system free SDA3


	driveFileSystemFreeSDA3=$(echo "$lsblkOutput" | grep "sda3" | awk '{print $4"B"}')
	
	#Adding the block that display error message if the information is not available.
	if [ -z "$driveFileSystemFreeSDA3" ]; then 
		driveFileSystemFreeSDA3='Error! Data is unavailable.'
		
	else
		driveFileSystemFreeSDA3=$(echo "$lsblkOutput" | grep "sda3" | awk '{print $4"B"}')
		
	fi

	

#Drive mount point 0.


	driveMountPoint0=$(echo "$lsblkOutput" | grep "sda" | awk 'FNR==1 {print $7}')
	
	#Adding the block that display error message if the information is not available.
	if [ -z "$driveMountPoint0" ]; then 
		driveMountPoint0='Error! Data is unavailable.'
		
	else
		driveMountPoint0=$(echo "$lsblkOutput" | grep "sda" | awk 'FNR==1 {print $7}')
		
	fi
	

#Drive mount point 1.


	driveMountPoint1=$(echo "$lsblkOutput" | grep "sda" | awk 'FNR==2 {print $7}')
	
	if [ -z "$driveMountPoint1" ]; then 
		driveMountPoint1='Error! Data is unavailable.'
		
	else
		driveMountPoint1=$(echo "$lsblkOutput" | grep "sda" | awk 'FNR==2 {print $7}')
		
	fi

#Drive mount point 2.


	driveMountPoint2=$(echo "$lsblkOutput" | grep "sda" | awk 'FNR==3 {print $7}')
	
	#Adding the block that display error message if the information is not available.
	if [ -z "$driveMountPoint2" ]; then 
		driveMountPoint2='Error! Data is unavailable.'
		
	else
		driveMountPoint2=$(echo "$lsblkOutput" | grep "sda" | awk 'FNR==3 {print $7}')
		
	fi


#Drive mount point 3.


	driveMountPoint3=$(echo "$lsblkOutput" | grep "sda" | awk 'FNR==4 {print $7}')
	
	#Adding the block that display error message if the information is not available.
	if [ -z "$driveMountPoint3" ]; then 
		driveMountPoint3='Error! Data is unavailable.'
		
	else
		driveMountPoint3=$(echo "$lsblkOutput" | grep "sda" | awk 'FNR==4 {print $7}')
		
	fi
	
	
#Display drive partition 0


	drivePartition0=$(echo "$lsblkOutput" | grep "sda" | awk 'FNR==1 {print $1}')
	
	#Adding the block that display error message if the information is not available.
	if [ -z "$drivePartition0" ]; then 
		drivePartition0='Error! Data is unavailable.'
		
	else
		drivePartition0=$(echo "$lsblkOutput" | grep "sda" | awk 'FNR==1 {print $1}')
		
	fi


#Display drive partition 1


	drivePartition1=$(echo "$lsblkOutput" | grep "sda1" | awk 'FNR==1 {print $1}' | tail -c 5)
	
	#Adding the block that display error message if the information is not available.
	if [ -z "$drivePartition1" ]; then 
		drivePartition1='Error! Data is unavailable.'
		
	else
		drivePartition1=$(echo "$lsblkOutput" | grep "sda1" | awk 'FNR==1 {print $1}' | tail -c 5)
		
	fi
	

#Display drive partition 2



	drivePartition2=$(echo "$lsblkOutput" | grep "sda2" | awk 'FNR==1 {print $1}' | tail -c 5)
	
	#Adding the block that display error message if the information is not available.
	if [ -z "$drivePartition2" ]; then 
		drivePartition2='Error! Data is unavailable.'
		
	else
		drivePartition2=$(echo "$lsblkOutput" | grep "sda2" | awk 'FNR==1 {print $1}' | tail -c 5)
		
	fi


#Display Drive Partition 3


	drivePartition3=$(echo "$lsblkOutput" | grep "sda3" | awk 'FNR==1 {print $1}' | tail -c 5)
	
	#Adding the block that display error message if the information is not available.
	if [ -z "$drivePartition3" ]; then 
		drivePartition3='Error! Data is unavailable.'
		
	else
	drivePartition3=$(echo "$lsblkOutput" | grep "sda3" | awk 'FNR==1 {print $1}' | tail -c 5)
	
	fi

#Display the disk information in the table form.


	diskTable=$(paste -d ';' <(echo "$drivePartition0" ; echo "$drivePartition1" ; echo "$drivePartition2" ; echo "$drivePartition3") <(echo "$driveManufacturer0" ; echo "$drivevendor1" ; echo "$drivevendor2" ; echo "$drivevendor3") <(echo "$driveModel" ; echo "N/A" ; echo "N/A" ; echo "N/A") <(echo "$driveSize0" ; echo "$driveSize1" ; echo "$driveSize2" ; echo "$driveSize3") <(echo "N/A" ; echo "N/A" ; echo "$driveFilesystemSizeSDA2" ; echo "$driveFilesystemSizeSDA3") <(echo "N/A" ; echo "N/A" ; echo "$driveFilesystemFreeSDA2" ; echo "$driveFilesystemFreeSDA3") <(echo "$driveMountPoint0" ; echo "$driveMountPoint1" ; echo "$driveMountPoint2" ; echo "$driveMountPoint3") | column -N 'Partition Name (/dev/sda)',Vendor,Model,Size,'Filesystem Size','Filesystem Free Space','Mount Point' -s ';' -o ' | ' -t) 

#Command to print the disk information assorted in table above.

cat <<EOF


---------DISK INFO----------

$diskTable

EOF
	}
	

#--------------------- RAM INFO --------------------#

#Create a function to get the components of RAM

function ramReport() {


#Cmd to get Ram name


	ramProductName=$(echo "$dmidecodeOutput" | grep -m1 -i "Product name" | awk '{$1=""; $2=""; print $0}')
	
	#Adding the block that display error message if the information is not available.
	if [ -z "$ramProductName" ]; then 
		ramProductName='Error! Data is unavailable.'
		
	else
		ramProductName=$(echo "$dmidecodeOutput" | grep -m1 -i "Product name" | awk '{$1=""; $2=""; print $0}')
		
	fi
	
	
#Cmd to get Ram Manufacturer

	ramManufacturer=$(echo "$dmidecodeOutput" | grep -m1 -i "manufacturer" | awk '{$1=""; print $0}')
	
	#Adding the block that display error message if the information is not available.
	if [ -z "$ramManufacturer" ]; then 
		ramManufacturer='Error! Data is unavailable.'
		
	else
		ramManufacturer=$(echo "$dmidecodeOutput" | grep -m1 -i "manufacturer" | awk '{$1=""; print $0}')
		
	fi
	

#Cmd to get Ram total size.


	totalSize=$(echo "$lshwOutput" | grep -A5 "\-memory" | grep -m1 'size:' | awk '{$1=""; print $0}')
	
	#Adding the block that display error message if the information is not available.
	if [ -z "$totalSize" ]; then 
		totalSize='Error! Data is unavailable.'
		
	else
		totalSize=$(echo "$lshwOutput" | grep -A5 "\-memory" | grep -m1 'size:' | awk '{$1=""; print $0}')
		
	fi	


#Cmd to get Ram serial number


	ramSerialNumber=$(echo "$dmidecodeOutput" | grep -m1 -i "serial number" | awk '{$1=""; print $0}')
	
	#Adding the block that display error message if the information is not available.
	if [ -z "$ramSerialNumber" ]; then 
		ramSerialNumber='Error! Data is unavailable.'
		
	else
		ramSerialNumber=$(echo "$dmidecodeOutput" | grep -m1 -i "serial number" | awk '{$1=""; print $0}')
		
	fi
	


#Cmd to get Ram Speed

	ramSpeed=$(echo "$dmidecodeOutput" --type 17 | grep -m1 Speed | awk '{$1=""; print $0}')
	
	#Adding the block that display error message if the information is not available.
	if [ -z "$ramSpeed" ]; then 
		ramSpeed='Error! Data is unavailable.'
		
	else
		ramSpeed=$(echo "$dmidecodeOutput" --type 17 | grep -m1 Speed | awk '{$1=""; print $0}')
		
	fi

#Cmd to get Ram Size


	ramSize=$(echo "$lshwOutput" | grep -A10 "\-memory" | grep 'size:' | awk 'FNR == 2 {$1=""; print $0}')
	
	#Adding the block that display error message if the information is not available.
	if [ -z "$ramSize" ]; then 
		ramSize='Error! Data is unavailable.'
		
	else
		ramSize=$(echo "$lshwOutput" | grep -A10 "\-memory" | grep 'size:' | awk 'FNR == 2 {$1=""; print $0}')
		
	fi
	


#Cmd to get Ram Location


	ramLocation=$(echo "$lshwOutput" | grep -m1 'slot: RAM' |awk '{$1=""; $2=""; print $0}')
	
	#Adding the block that display error message if the information is not available.
	if [ -z "$ramLocation" ]; then 
		ramLocation='Error! Data is unavailable.'
		
	else
		ramLocation=$(echo "$lshwOutput" | grep -m1 'slot: RAM' |awk '{$1=""; $2=""; print $0}')
		
	fi
	


#Display the RAM information in the table form.

	ramTable=$(paste -d ';' <(echo "$ramProductName") <(echo "$ramManufacturer") <(echo "$ramSize") <(echo "$ramSerialNum") <(echo "$ramSpeed")  <(echo "$totalSize") <(echo "$ramLocation")| column -N Model,Manufacturer,Size,'Seial Number',Speed,'Total size',Location -s ';' -o ' | ' -t)	

#display the table for RAM info.

cat <<EOF



------------- RAM INFO --------------


$ramTable

EOF
}


#----------------------------------- Video Report ------------------------------------------------------

#Create a video report function.

function videoReport() {

#Cmd to get Video manufacturer.


	videoManufacturer=$(lshw -class display | grep "vendor:" | awk '{print $2}')
	
	#Adding the block that display error message if the information is not available.
	if [ -z "$videoManufacturer" ]; then 
		videoManufacturer='Error! Data is unavailable.'
		
	else
		videoManufacturer=$(lshw -class display | grep "vendor:" | awk '{print $2}')
		
	fi
	


#Cmd to get Video description.


	videoDescription=$(lshw -C display | grep 'description:' | awk '{$1=""; print $0}')
	
	#Adding the block that display error message if the information is not available.
	if [ -z "$videoDescription" ]; then 
		videoDescription='Error! Data is unavailable.'
		
	else
		videoDescription=$(lshw -C display | grep 'description:' | awk '{$1=""; print $0}')
		
	fi
	



#Display the information of videoReport function.	
cat <<EOF



-------------VIDEO INFORMATION--------------


Manufacturer=$videoManufacturer


Description=$videoDescription


EOF
	
	}
	
	
#-------------------COMPUTER INFO --------------------#


#Create a function for Computer information.


function computerReport() {

	#Cmd to get the computer manufacturer.
	
	cmpManufacturer=$(echo "$lshwOutput" -class system | grep 'vendor:' | head -1 | awk '{$1=""; print $0}') 
	
	#Adding the block that display error message if the information is not available.
	if [ -z "$cmpManufacturer" ]; then
		cmpManufacturer='Error! Data is unavailable.'

  		
	else
		cmpManufacturer=$(echo "$lshwOutput" -class system | grep 'vendor:' | head -1 | awk '{$1=""; print $0}')
		
	fi
	
	
	#Cmd to get the Computer description or model.
	
	cmpDescription=$(echo "$lshwOutput" -class system | grep -m1 -i 'description:' | awk '{print $2}')
	
	#Adding the block that display error message if the information is not available.
	if [ -z "$cmpDescription" ]; then 
		cmpDescription='Error! Data is unavailable.'
	else
		cmpDescription=$(echo "$lshwOutput" -class system | grep -m1 -i 'description:' | awk '{print $2}')
	fi
	
	
	#Cmd to get the Computer serial number.
	

	cmpSerial=$(echo "$lshwOutput" -class system | grep -m1 -i 'serial: ' | awk '{$1=""; print $0}')
	
	#Adding the block that display error message if the information is not available.
	if [ -z "$cmpSerial" ]; then 
		cmpSerial='Error! Data is unavailable.'
		
	else
		cmpSerial=$(echo "$lshwOutput" -class system | grep -m1 -i 'serial: ' | awk '{$1=""; print $0}')
		
	fi
	
#Display the system information.

cat <<EOF



----------SYSTEM INFO -----------

Computer manufacturer=         $cmpManufacturer

Computer description or model=  $cmpDescription

Computer serial number=        $cmpSerial

EOF
	
}	

#-------------------- OS INFORMATION --------------------#

function osReport() {

	#Cmd to get Os distro version.
	
	distroVersion=$(hostnamectl | grep 'Kernel: ' | awk '{$1=""; print $0}')
	
	#Adding the block that display error message if the information is not available.
	if [ -z "$cmpdescription" ]; then 
		distroVersion='Error! Data is unavailable.'
		
	else
		distroVersion=$(hostnamectl | grep 'Kernel: ' | awk '{$1=""; print $0}')
		
	fi

	#Heading and command for The operating system name and version
	
	HostInformation=$(hostnamectl | awk 'FNR == 7 {print $3, $4, $5}')
	
	
#Display the OS information.

cat <<EOF
 

---------OS INFOPRMATION-----------

Linux distro=$HostInformation

Distro version=$distroVersion

EOF
	
}

#This function displays help information if the user asks for it on the command line or gives us a bad command line

function displayHelp {
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

function errorMessage() {
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
  
  local errormessage="$1"
    echo "[$timestamp] $errormessage" >> /var/log/systeminfo.log
    if [[ "$verbose" == true ]]; then 
    echo "Error has occured at [$timestamp] for invalid option: $errormessage ; Refer to help section (sysinfo.sh -h)"
    fi
    
}

