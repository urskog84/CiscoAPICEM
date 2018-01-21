<#

.SYNOPSIS
 GET all vlan from Netwok Device

.DESCRIPTION
Gets all vlan form a specific network device ID

.EXAMPLE
Get-APICEMvlan -Computername $APIC_HOST -APICticket $APICticket -DeviceID "5b5ea8da-8c23-486a-b95e-7429684d25fc"

#>
Function Get-APICEMvlan{
    [OutputType([system.object[]])]
    [cmdletbinding()]
    param(
        [Parameter (Mandatory = $False)]
        [ValidateNotNullOrEmpty()]
        [PSCustomObject]$connect = $Global:APICEMConnection,
        [Parameter(Mandatory = $true,Position = 0,HelpMessage = 'NetworkDeviceID')]
        [ValidateNotNullorEmpty()]
        [String]$NetworkDeviceID
        )

    Begin {
        $Uri = $connect.baseURL + "/network-device/" + $NetworkDeviceID + "/vlan"
        }

    Process {
        $Response = Invoke-RestMethod -Uri $Uri -Method "Get" -Headers $connect.Headers 
        return $Response.response
    }
}