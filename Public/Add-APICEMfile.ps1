<#

.SYNOPSIS
 Add/Upload a File to APIC Controller

.DESCRIPTION
Upload a new file within a specific nameSpace

.EXAMPLE
Add-APICEMfile -FilePath 'c:\temp\test\POD-SWA-02.txt' -NameSpace config

#>


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

        $fileName = $FilePath.Split("\")[-1]
       
        $fileBin = [IO.File]::ReadAllBytes($FilePath)
        $enc = [System.Text.Encoding]::GetEncoding("iso-8859-1")
        $fileEnc = $enc.GetString($fileBin)
       
        $boundary = [System.Guid]::NewGuid().ToString()
            
       
        $LF = "`r`n"

        # Build Body for our form-data manually since PS does not support multipart/form-data out of the box
        $bodyLines = (
            "--$boundary",
            "Content-Disposition: form-data; name=`"fileUpload`"; filename=`"$fileName`"",
            "Content-Type: text/plain$LF",
            $fileEnc,
            "--$boundary",
            "Content-Disposition: form-data; name=`"scope`"$LF",
            "ALL",
            "--$boundary--$LF"
        ) -join $LF
            
        $Uri = $connect.baseURL + "/file/" + $NameSpace
        #  $connect.headers.Remove('Content-Type')
        

    }
    process {
        write-Verbose $bodyLines
        Invoke-RestMethod -Uri $uri -Method Post -ContentType "multipart/form-data; boundary=$boundary" -Headers $connect.Headers -Body $bodyLines
    }
}