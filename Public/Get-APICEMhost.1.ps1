<#

.SYNOPSIS
 GET all devices from APIC Controller

.DESCRIPTION
Gets the list of all network devices filtered using management IP address, mac address, hostname and location name

.EXAMPLE
Get-APICEMnetwokrDevice -Computername $APIC_HOST -APICticket $APICticket

#>

Function Get-APICEMhost {
    [OutputType([system.object[]])]
    [cmdletbinding()]
    param(
        [Parameter (Mandatory = $False)]
        [ValidateNotNullOrEmpty()]
        [PSCustomObject]$connect = $Global:APICEMConnection,
        [Parameter (Mandatory = $False, HelpMessage='MacAddress')]
        [ValidateNotNullOrEmpty()]
        [String]$Mac,
        [Parameter (Mandatory = $False, HelpMessage='IpAddress')]
        [ValidateNotNullOrEmpty()]
        [String]$Ip
    )

    Begin {
        if ($mac) {
            $mac = Convert-MacAddress -mac $mac
            $Uri = $connect.baseURL + "/host?hostMac=" + $mac
        }
        elseif ($ip){
            $Uri = $connect.baseURL + "/host?hostIp=" + $ip
        }
        else {
            $Uri = $connect.baseURL + "/host"
        }
    }
    Process {
        $Response = Invoke-RestMethod -Uri $Uri -Method "Get" -Headers $connect.Headers
        return $Response.response
    }
}