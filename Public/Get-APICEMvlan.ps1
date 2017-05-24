<#

.SYNOPSIS
 GET all vlan from Netwok Device

.DESCRIPTION
Gets all vlan form a specific network device ID

.EXAMPLE
Get-APICEMnetwokr-device -Computername $APIC_HOST -APICticket $APICticket

#>
Function Get-APICEMvlan{
    [OutputType([system.object[]])]
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $true,Position = 1,HelpMessage = "hostname.domain.com")]
        [String]$Computername,
        [Parameter(Mandatory = $true,Position = 0,HelpMessage = 'APICticket object use Get-APICEMticket')]
        [ValidateNotNullorEmpty()]
        [psobject]$APICticket,
        [Parameter(Mandatory = $true,Position = 0,HelpMessage = 'DeviceID')]
        [ValidateNotNullorEmpty()]
        [String]$DeviceID
        )

    Begin {
        $Uri = "https://" + $Computername + "/api/v1/network-device/" + $DeviceID + "/vlan"
        $Headers = Get-Headers -APICticket $APICticket
        }

    Process {
        $Response = Invoke-RestMethod -Uri $Uri -Method "Get" -Headers $Headers 
        return $Response.response
    }
}