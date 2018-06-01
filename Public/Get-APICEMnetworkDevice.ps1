<#

.SYNOPSIS
 GET all devices from APIC Controller

.DESCRIPTION
Gets the list of all network devices filtered using management IP address, mac address, hostname and location name

.EXAMPLE
Get-APICEMnetwokrDevice -Computername $APIC_HOST -APICticket $APICticket

#>

Function Get-APICEMnetworkDevice {
    [OutputType([system.object[]])]
    [cmdletbinding()]
    param(
        [Parameter (Mandatory = $False)]
        [ValidateNotNullOrEmpty()]
        [PSCustomObject]$connect = $Global:APICEMConnection
    )

    Begin {
        $Uri = $connect.baseURL + "/network-device"
    }

    Process {
        $Response = Invoke-Handeler -Uri $Uri -Method "Get" -Headers $connect.Headers
        return $Response.response
    }
}