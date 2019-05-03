    
<#
	.SYNOPSIS
        To check if a particular account is being used somewhere
    .AUTHOR
        Renato Regalado    
	.DESCRIPTION
        Takes a username or user list parameter and iterates through each computer in the domain to check if it is being used 
        anywhere as a service or scheduled task
	.PARAMETER  username
		SAMACCOUNTNAME of the User ID
	.PARAMETER  userList
		list of users' SAMACCOUNTNAMEs
	.EXAMPLE 1
        PS C:\> .\ServiceAccountUsageReport.ps1 -username john.doe
    .EXAMPLE 2
        PS c:\> .\ServiceAccountUsageReport.ps1 -userList 

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