Function Invoke-Handeler {
    param(
        [Parameter (Mandatory = $False)]
        [ValidateNotNullOrEmpty()]
        [PSCustomObject]$connect = $Global:APICEMConnection,
        [Parameter (Mandatory = $false, HelpMessage = 'Http Method')]
        [ValidateNotNullOrEmpty()]
        [String]$Method,
        [Parameter (Mandatory = $false, HelpMessage = 'Headers')]
        [String]$Headers,
        [Parameter (Mandatory = $true, HelpMessage = 'Uri')]
        [ValidateNotNullOrEmpty()]
        [String]$Uri,
        [Parameter (Mandatory = $false, HelpMessage = 'Body')]
        [String]$Body,
        [Parameter (Mandatory = $false, HelpMessage = 'ContentType')]
        [String]$ContentType = 'application/json'
    ) 
    begin {
    }
    process {
    
        if ($Body) {
            if (($connect.SkipCertificateCheck) -and ($PSVersionTable.PSEdition -eq 'Core')) {
                $Respone = Invoke-RestMethod -Uri $Uri -Method $Method -ContentType $ContentType -Headers $connect.Headers -Body $Body -SkipCertificateCheck
            }
            else {
                $Respone = Invoke-RestMethod -Uri $Uri -Method $Method -ContentType $ContentType -Headers $connect.Headers -Body $Body 
            }
        }
        else {
            if ($connect.SkipCertificateCheck -and ($PSVersionTable.PSEdition -eq 'Core')) {
                $Respone = Invoke-RestMethod -Uri $Uri -Method $Method -ContentType $ContentType -Headers $connect.Headers -SkipCertificateCheck 

            }
            else {
                $Respone = Invoke-RestMethod -Uri $Uri -Method $Method -ContentType $ContentType -Headers $connect.Headers
            }
        }



        return $Respone
    }
    
}
