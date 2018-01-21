<#

.SYNOPSIS
 GET all vlan from Netwok Device

.DESCRIPTION
Gets all vlan form a specific network device ID

.EXAMPLE
Get-APICEMvlan -Computername $APIC_HOST -APICticket $APICticket -DeviceID "5b5ea8da-8c23-486a-b95e-7429684d25fc"

#>
Function Get-APICEMGlobalCredential {
    [OutputType([system.object[]])]
    [cmdletbinding()]
    param(
        [Parameter (Mandatory = $False)]
        [ValidateNotNullOrEmpty()]
        [PSCustomObject]$connect = $Global:APICEMConnection,
        [Parameter(Mandatory = $False, HelpMessage = 'SubType')]
        [ValidateNotNullorEmpty()]
        [ValidateSet("CLI", "SNMPV2_READ_COMMUNITY", "SNMPV2_WRITE_COMMUNITY", "SNMPV3")]
        [String]$credentialSubType,
        [Parameter (Mandatory = $False, HelpMessage = 'ID')]
        [ValidateNotNullOrEmpty()]
        [String]$ID
    )

    Begin {
        if ($credentialSubType) {
            $Uri = $connect.baseURL + "/global-credential?credentialSubType=" + $credentialSubType
        }
        elseif ($ID) {
            $Uri = $connect.baseURL + "/global-credential/" + $ID
        }
    }

    Process {
        $Response = Invoke-RestMethod -Uri $Uri -Method "Get" -Headers $connect.Headers 
        return $Response.response
    }
}