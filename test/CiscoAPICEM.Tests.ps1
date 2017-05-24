$ModuleManifestName = 'CiscoAPICEM.psd1'
$ModuleManifestPath = "$PSScriptRoot\..\$ModuleManifestName"

Describe 'Module Manifest Tests' {
    It 'Passes Test-ModuleManifest' {
        Test-ModuleManifest -Path $ModuleManifestPath
        $? | Should Be $true
    }
}

$APIC_HOST = "sandboxapic.cisco.com"

if(!$APIC_cred){$APIC_CRED = Get-Credential -UserName "devnetuser"}

Get-APICEMTicket -Credential $APIC_cred -Computername $APIC_HOST
