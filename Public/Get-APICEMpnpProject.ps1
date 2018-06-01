<#

.SYNOPSIS
 GET all pnpProject from APIC Controller

.DESCRIPTION
Gets the list of all Network Plug and Play Projects

.EXAMPLE
Get-APICEMpnpProject

#>

Function Get-APICEMpnpProject {
    param(
        [Parameter (Mandatory = $False)]
        [ValidateNotNullOrEmpty()]
        [PSCustomObject]$connect = $Global:APICEMConnection
    )

    Begin {
        $Uri = $connect.baseURL + "/pnp-project?offset=1&limit=100"
    }

    Process {
        $Response = Invoke-Handeler -Uri $Uri -Method Get -Headers $connect.Headers
        return $Response.response
    }
}