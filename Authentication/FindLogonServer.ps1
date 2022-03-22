
<#
    This script lists the DC names which are authenticating the current logged on user against a specific service. 
    This will list DC names which authenticated the user and service name against which the user was authenticated. 
    This script is only valid for Kerberos authentication. 
    By default the script will show DC name and service. 
    For listing ticket information, modify the output of $Result
#>

#------------------------------ Main Script Block -----------------------------------------#
## getting cached kerberos tickets 
$Klist = cmd /c "klist"

## Filtering the fields of tickets 
$UserNames = $Klist | Where-Object { $_ -like '*client:*' }
$ResourceServices = $Klist | Where-Object { $_ -like '*Server:*' }
$AuthenticatingDCs = Klist | Where-Object { $_ -like '*Kdc Called: *' }
$TicketIssueTimes = $Klist | Where-Object { $_ -like '*Start Time: *' }
$TicketExpireTimes = $Klist | Where-Object { $_ -like '*End Time:   *' }
$TicketEncryptionType = $Klist | Where-Object { $_ -like '*KerbTicket Encryption Type: *' }
$TicketFlags = $Klist | Where-Object { $_ -like '*Ticket Flags *' }

## Getting fields into a variable $Result
$Result = @()
for ($i = 0; $i -lt $UserNames.Count; $i++) {
    
    $Result += [PSCustomObject]@{
        UserName             = ($UserNames[$i] -split "Client: ")[-1] -replace "\s", ""
        ResourceService      = ($ResourceServices[$i] -split "Server: ")[-1] -replace "\s", ""
        AuthenticatingDC     = ($AuthenticatingDCs[$i] -split "Kdc Called: ")[-1]
        TicketIssueTime      = ($TicketIssueTimes[$i] -split "Start Time: ")[-1]
        TicketExpireTime     = ($TicketExpireTimes[$i] -split "End Time:   ")[-1]
        TicketEncryptionType = ($TicketEncryptionType[$i] -split "KerbTicket Encryption Type: ")[-1]
        TicketFlag           = ($TicketFlags[$i] -split "Ticket Flags ")[-1]
    }
}

$Result | Select-Object ResourceService, AuthenticatingDC

#------------------------------ Main Script Block -----------------------------------------#



