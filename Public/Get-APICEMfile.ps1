<#

.SYNOPSIS
 List all files on controller

.DESCRIPTION
This Funtion is used to obtain a list of files under a specific namespace

.EXAMPLE
Get-APICEMfile -NameSpace config

#>


Function Get-APICEMfile {
    [OutputType([system.object[]])]
    [cmdletbinding()]
    param(
        [Parameter (Mandatory = $False)]
        [ValidateNotNullOrEmpty()]
        [PSCustomObject]$connect = $Global:APICEMConnection,
        [Parameter (Mandatory = $true, HelpMessage = 'NameSpace')]
        [ValidateSet('ejbca', 'config', 'npclipreview')]
        [string]$NameSpace
    ) 
    begin {
        $Uri = $connect.baseURL + "/file/namespace/" + $NameSpace
    
    }
    process {
        $response = Invoke-Handeler -Uri $uri -Method Get # -Headers $connect.Headers
        return $response.response
    }
}