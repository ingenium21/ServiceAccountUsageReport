    
<#
	.SYNOPSIS
		To reset AD password for list of users
	.DESCRIPTION
		To reset AD user password and force to change at next logon.
		This script is built based on the request in TechNet Gallery.
	.PARAMETER  UserID
		SAMACCOUNTNAME of the User ID
	.PARAMETER  ParameterB
		Default Password or some string
	.EXAMPLE 1
		PS C:\> .\ResetUsersPasswords.ps1 
	.INPUTS
		System.String,System.String
		
	.NOTES
		Please test before comitting changes in environment.
#>

#Import relevant modules and Functions
import-Module activedirectory
. .\Functions\get-ServiceAccountUsage.ps1


param (
    $username,
    [String[]]$userList,
    $Server = get-AdComputer -filter *
)

if ($username) {
    get-ServiceAccountUsage -computerName $Server -UserAccount $username -errorAction silentlyContinue | Export-Csv .\ServiceAccountUsageReport\Results\"$username".csv
}

elseif ($userList) {

    foreach ($u in $userList) {
        get-ServiceAccountUsage -computerName $Server -UserAccount $u -errorAction silentlyContinue | Export-Csv .\ServiceAccountUsageReport\Results\"$u".csv
    }
}

Else {
    Write-host -BackgroundColor Black -ForegroundColor yellow "You need to input a user or list of users!"
}