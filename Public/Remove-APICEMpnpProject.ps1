<#

.SYNOPSIS
 Remove plug and play project from the 

.DESCRIPTION
This function is used to delete a fplug and play project with the specified Id

.EXAMPLE
Remove-APICEMpnpProject -projectid "81a1e1b5-416b-434c-8367-232d9e72c5eb"

#>


Function Remove-APICEMpnpProject {
    [OutputType([system.object[]])]
    [cmdletbinding()]
    param(
        [Parameter (Mandatory = $False)]
        [ValidateNotNullOrEmpty()]
        [PSCustomObject]$connect = $Global:APICEMConnection,
        [Parameter (Mandatory = $true, HelpMessage = 'projectid')]
        [ValidateNotNullOrEmpty()]
        [string]$projectid
    ) 
    begin {
        $Uri = $connect.baseURL + "/pnp-project/" + $projectid + "?deleteRule=1&deleteDevice=1"
    
    }
    process {
        $response = Invoke-Handeler -Uri $uri -Method Delete -Headers $connect.Headers
        return $response.response
    }
}