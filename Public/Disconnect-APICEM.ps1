function Disconnect-APICEM {

    <#
    .SYNOPSIS
    Destroys the $APICEMConnection global variable if it exists.

    .DESCRIPTION
    REST is not connection oriented, so there really isnt a connect/disconnect
    concept.  Disconnect-APICEM, merely removes the $APICEMConnection.

    .EXAMPLE
    Connect-NsxServer -Server nsxserver -username admin -Password VMware1!

    #>
    if (Get-Variable -Name APICEMConnection -scope global ) {
        Remove-Variable -name APICEMConnection -scope global
    }
}