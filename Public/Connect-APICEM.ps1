function Connect-APICEM {
    param (
        [Parameter (Mandatory = $true, HelpMessage = "APIC EM server" )]
        [ValidateNotNullOrEmpty()]
        [String]$APICServer,
        [Parameter(Mandatory = $true, HelpMessage = 'Credentials')]
        [ValidateNotNullorEmpty()]
        [System.Management.Automation.PSCredential]$Credential,
        [Parameter (Mandatory = $false, HelpMessage = 'SkipCertificateCheck')]
        [ValidateSet($false, $true)]
        [bool]$SkipCertificateCheck = $false
    )
    Begin {
        if ($SkipCertificateCheck) {
            #Allow untrusted SSL certs
            if (($PSVersionTable.PSEdition -eq 'Core')) {
                $PSDefaultParameterValues = $null

            }
            else {
                if ( [System.Net.ServicePointManager]::CertificatePolicy.ToString() -ne "TrustAllCertsPolicy" ) {
                    Add-Type -TypeDefinition @"
using System.Net;
using System.Security.Cryptography.X509Certificates;
public class TrustAllCertsPolicy : ICertificatePolicy {
    public bool CheckValidationResult(
        ServicePoint srvPoint, X509Certificate certificate,
        WebRequest request, int certificateProblem) {
        return true;
    }
}
"@
            
            
                    [System.Net.ServicePointManager]::CertificatePolicy = New-Object -TypeName TrustAllCertsPolicy
                }
            }
        }
    }
    process {
        try {
            if ($SkipCertificateCheck) {
                $APIticket = Get-APICEMTicket -Credential $Credential -Computername $APICServer -SkipCertificateCheck $SkipCertificateCheck
            }
            else {
                $APIticket = Get-APICEMTicket -Credential $Credential -Computername $APICServer
            }
        }
        catch {
            throw "error getting APIticket from $APICServer"
        }

        $connection = [pscustomObject] @{
            "APITicket"            = $APIticket
            "baseURL"              = "https://$APICServer/api/v1"
            "headers"              = @{
                'X-Auth-token' = $APIticket.response.serviceTicket
                'Content-Type' = 'application/json'
            }
            "SkipCertificateCheck" = $SkipCertificateCheck
        }

        set-variable -name APICEMConnection -value $connection -scope Global

        return $connection
    }
}