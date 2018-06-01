<#

.SYNOPSIS
 GET all devices from APIC Controller

.DESCRIPTION
Gets the list of all network devices filtered using management IP address, mac address, hostname and location name

.EXAMPLE
Get-APICEMnetwokrDevice -Computername $APIC_HOST -APICticket $APICticket

#>

Function Add-APICEMpnpProject {
    param(
        [Parameter (Mandatory = $False)]
        [ValidateNotNullOrEmpty()]
        [PSCustomObject]$connect = $Global:APICEMConnection,
        [Parameter (Mandatory = $False, HelpMessage = 'state')]
        [ValidateSet('PRE_PROVISIONED', 'IN_PROGRESS', 'PROVISIONED')] 
        [string]$state,
        [Parameter (Mandatory = $False, HelpMessage = 'siteName')]
        [ValidateNotNullOrEmpty()]
        [string]$siteName,
        [Parameter (Mandatory = $False, HelpMessage = 'tftpServer')]
        [ValidateNotNullOrEmpty()]
        [string]$tftpServer,
        [Parameter (Mandatory = $False, HelpMessage = 'tftpPath')]
        [ValidateNotNullOrEmpty()]
        [string]$tftpPath
    )
    Begin {
        $jsonbody = @"
        [
            {
                "siteName"   : "$siteName",
                "tftpServer" : "$tftpServer",
                "tftpPath"   : "$tftpPath"
            }
        ]
"@
        $Uri = $connect.baseURL + "/pnp-project"
    }
    Process {
        Write-Verbose $jsonbody
        $response = Invoke-Handeler -Uri $Uri -Method Post -Headers $connect.Headers -Body $jsonbody
        return $response.response
    }
}