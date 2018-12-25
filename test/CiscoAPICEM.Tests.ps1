
$ModuleManifestName = 'CiscoAPICEM.psd1'
$ModuleManifestPath = "$PSScriptRoot\..\$ModuleManifestName"
$APIC_HOST = "sandboxapic.cisco.com"

Describe 'Module Manifest Tests' {
    It 'Passes Test-ModuleManifest' {
        Test-ModuleManifest -Path $ModuleManifestPath
        $? | Should Be $true
    }
}



if ($PSVersionTable.PSEdition -eq 'Core') {
    Import-Module "$PSScriptRoot/../CiscoAPICEM" -Force
    $testFile = "$PSScriptRoot/POD-SWA-02.txt"
}
else {
    Import-Module "$PSScriptRoot\..\CiscoAPICEM" -Force
    $testFile = "$PSScriptRoot\POD-SWA-02.txt"
}




# Create PSCredential Oject
$secpasswd = ConvertTo-SecureString "Cisco123!" -AsPlainText -Force
$APIC_CRED = New-Object System.Management.Automation.PSCredential ("devnetuser", $secpasswd)


Describe 'Get-APICEMticket' { 
    it "Test Ticket funtion" {
        $token = Get-APICEMticket -Credential $APIC_CRED -Computername $APIC_HOST
        $token.response.serviceTicket            | Should -Match "-cas"
        $token.response.idleTimeout.Count         | Should -Be 1
        $token.response.sessionTimeout.Count      | Should -Be 1
    }
    it "Test Ticket funtion -SkipCertificateCheck:$true" {
        $token = Get-APICEMticket -Credential $APIC_CRED -Computername $APIC_HOST -SkipCertificateCheck:$true
        $token.response.serviceTicket            | Should -Match "-cas"
        $token.response.idleTimeout.Count         | Should -Be 1
        $token.response.sessionTimeout.Count      | Should -Be 1
    }
}

Describe 'Connect-APICEM' {
    it "Connection to APIC-EM" {
        $APIPConnection = Connect-APICEM -APICServer $APIC_HOST -Credential $APIC_cred -SkipCertificateCheck:$true
        $APIPConnection.PSobject.Properties.name[0] | Should BeExactly "APITicket"
        $APIPConnection.PSobject.Properties.name[1] |  Should BeExactly "baseURL"
        $APIPConnection.PSobject.Properties.name[2] | Should BeExactly "headers"
    }
    it "Test Global Variable" {
        test-path -path Variable:APICEMConnection | Should -Be $true
    }
    it "Non Correct Host" {
        {Connect-APICEM -APICServer nonvalidhost.com -Credential $APIC_cred} | Should -Throw 
    }
}

Describe 'Get-APICEMnetworkDevice' {
    it "Getting Neworkdevices" {
        $Devices = Get-APICEMnetworkDevice
        $Devices.Count | Should -BeGreaterThan 0
    }
}

Describe 'Get-APICEMhost' {
    it "list all host" {
        $APICHosts = Get-APICEMhost
        $APICHosts.hostIp.Count | Should -BeGreaterThan 0
    }
    it "list host with mac 5c:f9:dd:52:07:78" {
        #$APIPConnection = Connect-APICEM -APICServer $APIC_HOST -Credential $APIC_cred
        $APICHost = Get-APICEMhost -mac "5c:f9:dd:52:07:78"
        $APICHost.hostMac | Should -Be "5c:f9:dd:52:07:78"
    }
    it "list host with ip 10.1.15.117" {
        #$APIPConnection = Connect-APICEM -APICServer $APIC_HOST -Credential $APIC_cred
        $APICHost = Get-APICEMhost -ip "10.2.1.22"
        $APICHost.hostIp | Should -Be "10.2.1.22"
    }
}

Describe 'Get-APICEMpnp-device' {
    it "Get all pnp devices" {
        $pnpdevices = Get-APICEMpnpDevice
        $pnpdevices | Should -no -BeNullOrEmpty
        $pnpdevices.count | Should -BeGreaterThan 1
    }
    it "Get 1 pnp devices -hostname" {
        $pnpdevices = Get-APICEMpnpDevice -hostname "AHEC-2960C1"
        $pnpdevices.hostName | Should -MatchExactly "AHEC-2960C1"
        $pnpdevices[1]| Should -BeNullOrEmpty
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

Describe 'Get-APICEMfile' {
    it "List all files" {
        $allFiles = Get-APICEMfile -NameSpace config
        $allFiles.count | Should -BeGreaterThan 0
    }
}

write-host "Path to Configfile" -ForegroundColor Green
write-host $testFile -ForegroundColor Green

Describe 'Add-APICEMfile' {
    it "Upload Config file POD-SWA-02.txt" {
        $file = Add-APICEMfile -FilePath $testFile -NameSpace config
        $file.name | Should -Be "POD-SWA-02.txt"
    }
    it "Not Valid path" {
        { Add-APICEMfile -FilePath .\POD-SWA.txt -NameSpace config } | Should -Throw ".\POD-SWA.txt Not valid path"
    }
}

Describe 'Get-APICEMfile' {
    it "List all files" {
        $allFiles = Get-APICEMfile -NameSpace config
        $allFiles.count | Should -BeGreaterThan 0
    }
}

# Setup fore Remove-APICEMfileGet-APICEMfile -NameSpace config -Verbose
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
        $test.count | Should -BeGreaterThan 3
        $test[1].provisionedBy | Should -no -BeNullOrEmpty
    }
}




Describe 'Add-APICEMpnpProject' {
    it "Add a pnpProject" {
        $test = Add-APICEMpnpProject -state IN_PROGRESS -siteName FSP -tftpServer "192.168.1.20" -tftpPath "/"
        $test.taskId | Should -not -be $null
        $test.url | Should -not -be $null
    }
}


$siteFSP = Get-APICEMpnpProject | Where-Object {$_.siteName -eq "FSP"}

Describe "Add-APICEMpnpDevice" {
    it "Add a pnpDevice" {
        $pnpDevice = Add-APICEMpnpDevice -projectid $siteFSP.id -serialNumber "FOC1637Y2GJ" -platformid "WS-C3850-24P" -hostName "FSSWI-DA-02"
        $pnpDevice.taskId | Should -not -be $null
        $pnpDevice.url | Should -not -be $null

    }
}


Describe "Delete-APICEMpnpProject" {
    it "Delete a pnpProject" {
        $pnpDevice = Remove-APICEMpnpProject -projectid $siteFSP.id 
        $pnpDevice.taskId | Should -not -be $null
        $pnpDevice.url | Should -not -be $null
    }
}

<#
Describe 'Disconnect-APICEM' {
    it "remove Global vaibale" {
        Disconnect-APICEM
        test-path -path Variable:APICEMConnection | Should -Be $false
    }
}
#>