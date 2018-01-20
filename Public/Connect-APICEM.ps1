function Connect-APICEM  {
    param (
        [Parameter (Mandatory=$true, HelpMessage ="APIC EM server" )]
        [ValidateNotNullOrEmpty()]
        [String]$APICServer,
        [Parameter(Mandatory = $true, HelpMessage = 'Credentials')]
        [ValidateNotNullorEmpty()]
        [System.Management.Automation.PSCredential]$Credential
    )

try {
   $APIticket = Get-APICEMTicket -Credential $Credential -Computername $APICServer
}
catch {
    Write-Host "error getting APIticket" -ForegroundColor Red
    break 
}

    $connection = [pscustomObject] @{
        "APITicket" = $APIticket
        "baseURL" = "https://$APICServer/api/v1"
        "headers" = @{
            'X-Auth-token' = $APIticket.response.serviceTicket
            'Content-Type' = 'application/json'
             }
        }

        set-variable -name APICEMConnection -value $connection -scope Global

 return $connection
}