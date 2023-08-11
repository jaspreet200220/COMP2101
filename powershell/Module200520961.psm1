#-----------Describes the information about system, network and disks------------
  
      param([switch]$System,
      [switch]$Disks,
      [switch]$Network
)



#------------Provides the summary of Hardware-----------------------------------

if ($System) { 
	processorInfo
	osNameAndVersion
	ramSummary
	videoSummary
}


#------------Collects the information of Disk drive-----------------------------

elseif ($Disks) {
	diskDriveSummary
}


#-------------Description of network summary-----------------------------------

elseif ($Network) {
	networkSummary
}


#--------------Describes the summary of network, video, processor info-------------

else {
	osDesc
	osNameAndVersion
	processorInfo
	ramSummary
	diskDriveSummary
	networkSummary
	videoSummary
}
