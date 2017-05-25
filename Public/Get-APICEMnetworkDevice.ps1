<#

.SYNOPSIS
 GET all devices from APIC Controller

.DESCRIPTION
Gets the list of all network devices filtered using management IP address, mac address, hostname and location name

.EXAMPLE
Get-APICEMnetwokrDevice -Computername $APIC_HOST -APICticket $APICticket

#>

Function Get-APICEMnetworkDevice{
    [OutputType([system.object[]])]
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $true,Position = 1,HelpMessage = "hostname.domain.com")]
        [String]$Computername,
        [Parameter(Mandatory = $true,Position = 0,HelpMessage = 'APICticket object use Get-APICEMticket')]
        [ValidateNotNullorEmpty()]
        [psobject]$APICticket
        )

    Begin {
        $Uri = "https://" + $Computername + "/api/v1/network-device"
        $Headers = Get-Headers -APICticket $APICticket
        }

    Process {
        $Response = Invoke-RestMethod -Uri $Uri -Method "Get" -Headers $Headers 
        return $Response.response
    }
}