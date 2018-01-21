<#

.SYNOPSIS
 GET intefaces from APIC Controller

.DESCRIPTION
Gets the list of all network devices filtered using management IP address, mac address, hostname and location name

.EXAMPLE
Get-APICEMinterface
 -Lista all intefaces

Get-APICEMinterface -Ip "172.28.97.249"
  - Lists all interfaces with given interface ip address (no Device ip)

$interface = Get-APICEMinterface -NetworkDeviceID "4af8bf34-295f-46f4-97b7-0a2d2ea4cf22"
  - Lists all interfaces from a specific device

$interface = Get-APICEMinterface -NetworkDeviceID "4af8bf34-295f-46f4-97b7-0a2d2ea4cf22" -InterfaceName G
#>

Function Get-APICEMinterface {
    [OutputType([system.object[]])]
    [cmdletbinding()]
    param(
        [Parameter (Mandatory = $False)]
        [ValidateNotNullOrEmpty()]
        [PSCustomObject]$connect = $Global:APICEMConnection,
        [Parameter (Mandatory = $False, HelpMessage='NetworkDeviceID')]
        [ValidateNotNullOrEmpty()]
        [String]$NetworkDeviceID,
        [Parameter (Mandatory = $False, HelpMessage='IpAddress')]
        [ValidateNotNullOrEmpty()]
        [String]$Ip,
        [Parameter (Mandatory = $False, HelpMessage='InterfaceName')]
        [ValidateNotNullOrEmpty()]
        [String]$InterfaceName
        
    )

    Begin {
        if ($NetworkDeviceID) {
            $Uri = $connect.baseURL + "/interface/network-device/" + $NetworkDeviceID
            }
        if ($NetworkDeviceID -and $InterfaceName) {
                $intname = $InterfaceName.Replace("/","%2F")
                Write-Verbose -Message $intname
                $Uri = $connect.baseURL + "/interface/network-device/" + $NetworkDeviceID + "/interface-name?name=" + $intname
                    }
        elseif ($ip){
            $Uri = $connect.baseURL + "/interface/ip-address/" + $ip
        }
        else {
            $Uri = $connect.baseURL + "/interface"
        }
    }
    Process {
        $Response = Invoke-RestMethod -Uri $Uri -Method "Get" -Headers $connect.Headers
        return $Response.response
    }
}