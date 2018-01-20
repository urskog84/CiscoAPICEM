
$ModuleManifestName = 'CiscoAPICEM.psd1'
$ModuleManifestPath = "$PSScriptRoot\..\$ModuleManifestName"

Describe 'Module Manifest Tests' {
    It 'Passes Test-ModuleManifest' {
        Test-ModuleManifest -Path $ModuleManifestPath
        $? | Should Be $true
    }
}


Import-Module "C:\git\CiscoAPICEM" -Force
$APIC_HOST = "sandboxapic.cisco.com"


# Create PSCredential Oject
$secpasswd = ConvertTo-SecureString "Cisco123!" -AsPlainText -Force
$APIC_CRED = New-Object System.Management.Automation.PSCredential ("devnetuser", $secpasswd)


Describe 'Get-APICEMticket' { 
    it "Test Tciket funtion" {
    $token = Get-APICEMticket -Credential $APIC_CRED -Computername $APIC_HOST
    $token.response.serviceTicket            | Should -Match "-cas"
    $token.response.idleTimeout.Count         | Should -Be 1
    $token.response.sessionTimeout.Count      | Should -Be 1
    }
}

Describe 'Connect-APICEM' {
    it "Connection to APIC-EM" {
        $APIPConnection = Connect-APICEM -APICServer $APIC_HOST -Credential $APIC_cred
        $APIPConnection.PSobject.Properties.name[0] | Should BeExactly "APITicket"
        $APIPConnection.PSobject.Properties.name[1] |  Should BeExactly "baseURL"
        $APIPConnection.PSobject.Properties.name[2] | Should BeExactly "headers"
    }
    it "Test Global Variable" {
        test-path -path Variable:APICEMConnection | Should -Be $true
    }
}

Describe 'Get-APICEMnetworkDevice' {
    it "Getting Neworkdevices" {
        $APIPConnection = Connect-APICEM -APICServer $APIC_HOST -Credential $APIC_cred
        $Devices = Get-APICEMnetworkDevice -connect $APIPConnection
        $Devices.Count | Should -BeGreaterThan 0
    }
}

Describe 'Get-APICEMhost' {
    it "list all host" {
        $APIPConnection = Connect-APICEM -APICServer $APIC_HOST -Credential $APIC_cred
        $APICHosts = Get-APICEMhost -connect $APIPConnection
        $APICHosts.Count | Should -BeGreaterThan 0
    }
    it "list host with mac e8:9a:8f:7a:22:99" {
        #$APIPConnection = Connect-APICEM -APICServer $APIC_HOST -Credential $APIC_cred
        $APICHost = Get-APICEMhost -mac "e8:9a:8f:7a:22:99"
        $APICHost.hostMac | Should -Be "e8:9a:8f:7a:22:99"
    }
    it "list host with ip 10.1.15.117" {
        #$APIPConnection = Connect-APICEM -APICServer $APIC_HOST -Credential $APIC_cred
        $APICHost = Get-APICEMhost -ip "10.1.15.117"
        $APICHost.hostIp | Should -Be "10.1.15.117"
    }
}

Describe 'Get-APICEMpnp-device'{
    it "Get all pnp devices" {
        $pnpdevices = Get-APICEMpnpDevice
        $pnpdevices | Should -BeNullOrEmpty
    }
}

Describe 'Get-APICEMnetworkDevoceConfig'{
    it "Get all network Devoce Config" {
        $Config =    Get-APICEMnetworkDevoceConfig
        $Config.Count | Should -BeGreaterThan 0
    }    
}

Describe 'Disconnect-APICEM' {
    it "remove Global vaibale" {
        Disconnect-APICEM
        test-path -path Variable:APICEMConnection | Should -Be $false
    }
}