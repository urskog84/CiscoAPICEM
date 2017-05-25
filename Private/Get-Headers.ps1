Function Get-Headers{
    Param(
    [Parameter(Mandatory = $true,Position = 0,HelpMessage = 'APICticket object use Get-APICEMticket')]
    [ValidateNotNullorEmpty()]
    [psobject]$APICticket
    )
Process {
    $headers = @{
       'X-Auth-token' = $APICticket.serviceTicket
        }
    return $headers
    }
}