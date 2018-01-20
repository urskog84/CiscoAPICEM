function Convert-MacAddress {
    param
    (
        [Parameter(Mandatory = $true)]
        [String]$mac
    )
	
    BEGIN {
        # Initial Cleanup
        $mac = $mac -replace "-", "" #Replace Dash
        $mac = $mac -replace ":", "" #Replace Colon
        $mac = $mac -replace "/s", "" #Remove whitespace
        $mac = $mac -replace " ", "" #Remove whitespace
        $mac = $mac -replace "\.", "" #Remove dots
        $mac = $mac.trim() #Remove space at the beginning
        $mac = $mac.trimend() #Remove space at the end
    }
    PROCESS {
        $mac = ($mac -replace '(..(?!$))', "`$1:").tolower()
    }
    END {
        Write-Output $mac
    }
}