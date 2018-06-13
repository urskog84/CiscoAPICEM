# CiscoAPICEM
Powershell Modue for Cisco APIC-EM

# Release Notes
- 0.1.6
    - Adding Pester tests
    - Fix Bug in
        - Get-APICEMpnpDevice -hostName
- 0.1.5
    - Get-APICEMpnpDevice | add property hostName
    - Fix minor bug in
        *  Get-APICEMpnpDevice | Only retruns first 10, now can retrun 500
- 0.1.4
    - Fix minor bug in
        * Add-APICEMpnpDevice - fix property discoveryPassword [ValidateNotNullOrEmpty] 
        * Add-APICEMfile - add retrun statmanet
- 0.1.3
    - Add-APICMpnpDevice
    - Remove-APICEMpnpProject
- 0.1.2
    - Add-APICEMpnpProject
    - Get-APICMpnpProject
    - Get-APICEMfile
    - Remove-APICEMfile
- 0.1.1
    - Connect
    - Get-APICEMhost
    - Get-APICEMpnpdice
    - Get-APICEMnetwrokDevice
- 0.1.0
    - Get-APICEMhost
    - Get-APICEMpnpdice
    - Get-APICEMnetwrokDevice

# TO DO
- Publish to PowerShell Gallery
- Continuous delivery with circleci.com
- Powershell v6 Support