function restNotif ($msg) {
	$So =  $TSEnv:So
		$Rack = $TSEnv:Rack
		$Shelf = $TSEnv:Shelf
		$RackShelf = $Rack + "_" + $Shelf
		$PK = "[" + $So + "][" + $RackShelf + "]"

		$URL="http://10.0.205.204/SPOT/provisioning/api/provisioningnotifications/" + $PK
		$body = @{
			notifid = $PK
				status = $msg
		}
	invoke-RestMethod $URL -Method Put -ContentType "json" -Body (ConvertTo-Json $body) -UserAgent "perl"



}

#Setting Vars 
$DoUpdate = "DoUpdate.cmd" 
$ScriptRoot = $TSEnv:DeployDrive
$ScriptRoot = "$ScriptRoot\Scripts"
$UpdateCmd = "$ScriptRoot\wsusoffline\client\cmd\$DoUpdate"

#Performing Action 
restNotif "Mount Network share $uncServer to copy release(s) $ReleasesArr"
Write-Progress -Activity "Windows Updates Wrapper" -Status "Initialazing Windows Updates........." -PercentComplete 12 -Id 1 


#Start the updates

& "$UpdateCmd" | tee-object -variable $Msg && restNotif "$Msg"

Write-Progress -Activity "Windows Updates Wrapper" -Status "Windows updates terminated" -PercentComplete 100 -Id 1
restNotif  "Windows updates terminated"
