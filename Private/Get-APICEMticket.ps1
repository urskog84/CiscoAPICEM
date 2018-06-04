<#

.SYNOPSIS
 GET serviceTicket from APIC Controller

.DESCRIPTION
POST request to get API Key/ServiceTicket

.EXAMPLE
$APICticket = Get-APICEMTicket -Credential $APICcred -Computername $APICEM

#>
function Get-APICEMticket {
    Param(
        [Parameter(Mandatory = $true, Position = 0, HelpMessage = 'Credentials')]
        [ValidateNotNullorEmpty()]
        [System.Management.Automation.PSCredential]$Credential,
        [Parameter(Mandatory = $true, Position = 1, HelpMessage = "hostname.domain.com")]
        [String]$Computername,
        [Parameter (Mandatory = $false, HelpMessage = 'SkipCertificateCheck')]
        # [ValidateSet($false, $true)]
        [bool]$SkipCertificateCheck = $false
    )
    Begin {
        $URIaddress = "https://$Computername/api/v1/ticket"

        $UserName = $Credential.GetNetworkCredential().UserName
        $Password = $Credential.GetNetworkCredential().Password
        $JsonBody = @"
{
    "username" : "$UserName",
    "password" : "$Password"
}
"@
    }
    Process {
        if (($PSVersionTable.PSEdition -eq 'Core') -and ($SkipCertificateCheck)) {
            Write-Verbose "Core AND SkipCertificateChec"
            $response = Invoke-RestMethod -Uri $URIaddress -ContentType 'application/json' -Method Post -Body $JsonBody -SkipCertificateCheck
        }
        else {
            Write-Verbose "No SkipCertificateChec"
            $response = Invoke-RestMethod -Uri $URIaddress -ContentType 'application/json' -Method Post -Body $JsonBody
        }
        return $response

    }
}