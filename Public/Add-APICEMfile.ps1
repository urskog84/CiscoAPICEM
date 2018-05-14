Function Add-APICEMfile {
    [OutputType([system.object[]])]
    [cmdletbinding()]
    param(
        [Parameter (Mandatory = $False)]
        [ValidateNotNullOrEmpty()]
        [PSCustomObject]$connect = $Global:APICEMConnection,
        [Parameter (Mandatory = $False, HelpMessage = 'FilePath')]
        [ValidateNotNullOrEmpty()]
        [String]$FilePath,
        [Parameter (Mandatory = $true, HelpMessage = 'NameSpace')]
        [ValidateSet('ejbca', 'config', 'npclipreview')]
        [string]$NameSpace
    ) 
    begin {
        if (Test-Path -Path $FilePath) {
        }
        else {
            Write-Error "Not valid path"
            throw
        }
        $Uri = $connect.baseURL + "/file/" + $NameSpace
    }
    process {
        Invoke-RestMethod -Uri $uri -Method Post -InFile $FilePath -Headers $connect.Headers 
    }
}