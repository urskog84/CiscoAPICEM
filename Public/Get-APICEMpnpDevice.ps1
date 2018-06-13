Function GET-APICEMpnpDevice {
    <#

.SYNOPSIS
 GET all devices from APIC Controller

.DESCRIPTION
Gets the list of all network devices filtered using management IP address, mac address, hostname and location name

.EXAMPLE
Get-APICEMnetwokrDevice -Computername $APIC_HOST -APICticket $APICticket

#>
    [OutputType([system.object[]])]
    [cmdletbinding()]
    param(
        [Parameter (Mandatory = $False)]
        [ValidateNotNullOrEmpty()]
        [PSCustomObject]$connect = $Global:APICEMConnection,
        [Parameter (Mandatory = $False)]
        [ValidateNotNullOrEmpty()]
        [string]$hostName
    )
    Begin {
        if ($hostName) {
            $Uri = $connect.baseURL + "/pnp-device?hostName=" + $hostName    
        }
        else {
            $Uri = $connect.baseURL + "/pnp-device?matchDeviceState=true&offset=1&limit=500"
        }
    }
    Process {
        $Response = Invoke-Handeler -Uri $Uri -Method "Get" -Headers $connect.Headers
        return $Response.response
    }
}