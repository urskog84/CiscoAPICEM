
$ModuleManifestName = 'CiscoAPICEM.psd1'
$ModuleManifestPath = "$PSScriptRoot/../$ModuleManifestName"




$PSDefaultParameterValues.Add("Invoke-RestMethod:SkipCertificateCheck", $true)
$PSDefaultParameterValues.Add("Invoke-WebRequest:SkipCertificateCheck", $true)

Describe 'Module Manifest Tests' {
    It 'Passes Test-ModuleManifest' {
        Test-ModuleManifest -Path $ModuleManifestPath
        $? | Should Be $true
    }
}


Import-Module "$PSScriptRoot/../CiscoAPICEM" -Force
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
    it "list host with mac 5c:f9:dd:52:07:78" {
        #$APIPConnection = Connect-APICEM -APICServer $APIC_HOST -Credential $APIC_cred
        $APICHost = Get-APICEMhost -mac "5c:f9:dd:52:07:78"
        $APICHost.hostMac | Should -Be "5c:f9:dd:52:07:78"
    }
    it "list host with ip 10.1.15.117" {
        #$APIPConnection = Connect-APICEM -APICServer $APIC_HOST -Credential $APIC_cred
        $APICHost = Get-APICEMhost -ip "10.1.15.117"
        $APICHost.hostIp | Should -Be "10.1.15.117"
    }
}

Describe 'Get-APICEMpnp-device' {
    it "Get all pnp devices" {
        $pnpdevices = Get-APICEMpnpDevice
        $pnpdevices | Should -no -BeNullOrEmpty
    }
}

Describe 'Get-APICEMnetworkDevoceConfig' {
    it "Get all network Devoce Config" {
        $Config = Get-APICEMnetworkDevoceConfig
        $Config.Count | Should -BeGreaterThan 0
    }    
}

Describe 'Get-APICEMinterface' {
    it "Get all interface" {
        $interface = Get-APICEMinterface
        $interface.Count | Should -BeGreaterThan 0
    }
    it "Get all inteface from NetwrokDeviceID" {
        $interface = Get-APICEMinterface -NetworkDeviceID "4af8bf34-295f-46f4-97b7-0a2d2ea4cf22"
        $interface.Count | Should -BeGreaterThan 0

    }
    it "Get inteface from NetwrokDeviceID filter by InterfaceName" {
        $interface = Get-APICEMinterface -NetworkDeviceID "4af8bf34-295f-46f4-97b7-0a2d2ea4cf22" -InterfaceName "GigabitEthernet5/30"
        $interface.portName | Should -Be "GigabitEthernet5/30"

    }
    it "Get all inteface from inteface ip address " {
        $interface = Get-APICEMinterface -Ip "172.28.97.249"
        $interface.ipv4Address | Should -Be "172.28.97.249"
    }
}

Describe 'Get-APICEMvlan' {
    it "Get all vlan from NetworkDevice id" {
        $vlan = Get-APICEMvlan -NetworkDeviceID "c8ed3e49-5eeb-4dee-b120-edeb179c8394" 
        $vlan.Count | Should -BeGreaterThan 0
    }
    it "Get all Subinterface from NetworkDevice id" {
        $vlan = Get-APICEMvlan -NetworkDeviceID "d337811b-d371-444c-a49f-9e2791f955b4" -IsSubinterface true
        $vlan.Count | Should -BeGreaterThan 0
    }
}


Describe 'Get-GlobalCredental' {
    it "Get all GlobalCredentals with sub type CLI " {
        $GlobCred = Get-APICEMGlobalCredential -credentialSubType CLI
        $GlobCred.id.count | Should -BeGreaterThan 0
    }
    it "Get Specific GlobalCredental from ID" {
        $GlobCred = Get-APICEMGlobalCredential -ID "1a91b12a-62f7-4339-a4b4-9dd938f29684"
        $GlobCred.count | Should -Be 1
    }
}


Describe 'Add-APICEMfile' {
    it "Upload Config file POD-SWA-02.txt" {
        $file = Add-APICEMfile -FilePath "$PSScriptRoot/POD-SWA-02.txt" -NameSpace config
        $file.response.name | Should -Be "POD-SWA-02.txt"
    }
}


Describe 'Get-APICEMfile' {
    it "List all files" {
        $allFiles = Get-APICEMfile -NameSpace config
        $allFiles.count | Should -BeGreaterThan 0
    }
}


# Setup fore Remove-APICEMfile
$allFiles = Get-APICEMfile -NameSpace config 
$removefile = $allFiles | Where-Object {$_.name -EQ "POD-SWA-02.txt"}
Describe 'Remove-APICEMfile' {
    it "Remove file POD-SWA-02.txt " {
        $test = Remove-APICEMfile -id $removefile.id 
        $test | Should -Match "is deleted successfully"
    }
}


Describe 'Get-APICEMpnpProject' {
    it "List all pnpProject" {
        $test = Get-APICEMpnpProject
        $test.count | Should -BeGreaterThan 0
        $test[0].provisionedBy | Should -MatchExactly "devnetuser"
    }
}


Describe 'Add-APICEMpnpProject' {
    it "Add a pnpProject" {
        $test = Add-APICEMpnpProject -state IN_PROGRESS -siteName FSP -tftpServer "192.168.1.20" -tftpPath "/"  -Verbose
        $test.taskId | Should -not -be $null
        $test.url | Should -not -be $null
    }
}



Describe 'Disconnect-APICEM' {
    it "remove Global vaibale" {
        Disconnect-APICEM
        test-path -path Variable:APICEMConnection | Should -Be $false
    }
}
