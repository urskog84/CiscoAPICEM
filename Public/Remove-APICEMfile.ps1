<#

.SYNOPSIS
 Remove filele from the 

.DESCRIPTION
This function is used to delete a file associated with the specified fileId

.EXAMPLE
Get-APICEMfile -NameSpace config

#>


Function Remove-APICEMfile {
    [OutputType([system.object[]])]
    [cmdletbinding()]
    param(
        [Parameter (Mandatory = $False)]
        [ValidateNotNullOrEmpty()]
        [PSCustomObject]$connect = $Global:APICEMConnection,
        [Parameter (Mandatory = $true, HelpMessage = 'file id')]
        [ValidateNotNullOrEmpty()]
        [string]$id
    ) 
    begin {
        $Uri = $connect.baseURL + "/file/" + $id
    
    }
    process {
        $response = Invoke-RestMethod -Uri $uri -Method Delete -Headers $connect.Headers
        return $response.response
    }
}