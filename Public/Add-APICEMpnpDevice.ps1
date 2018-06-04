<#

.SYNOPSIS
Creates a new device under a given project


.DESCRIPTION
This Funtion is user to create a new device under a given project

.EXAMPLE
Add-APICEMpnpDevice -projectid $siteFSP.id -serialNumber "FOC1637Y2GJ" -platformid "WS-C3850-24P" -hostName "FSSWI-DA-02"

#>

Function Add-APICEMpnpDevice {
    param(
        [Parameter (Mandatory = $False)]
        [ValidateNotNullOrEmpty()]
        [PSCustomObject]$connect = $Global:APICEMConnection,
        [Parameter (Mandatory = $true, HelpMessage = 'projectid')]
        [ValidateNotNullOrEmpty()] 
        [string]$projectid,        
        [Parameter (Mandatory = $False, HelpMessage = 'serialNumber')]
        [ValidateNotNullOrEmpty()]
        [string]$serialNumber,
        [Parameter (Mandatory = $False, HelpMessage = 'configId')]
        [ValidateNotNullOrEmpty()]
        [string]$configId,
        [Parameter (Mandatory = $False, HelpMessage = 'hostName')]
        [ValidateNotNullOrEmpty()]
        [string]$hostName,
        [Parameter (Mandatory = $true, HelpMessage = 'platformId')]
        [ValidateNotNullOrEmpty()]
        [string]$platformId,
        [Parameter (Mandatory = $False, HelpMessage = 'discoveryUser')]
        [ValidateNotNullOrEmpty()]
        [string]$discoveryUser,
        [Parameter (Mandatory = $False, HelpMessage = 'discoveryPassword')]
        [ValidateNotNullOrEmpty]
        [string]$discoveryPassword
    )
    Begin {
        $jsonbody = @"
        [
            {
              "serialNumber": "$serialNumber",
              "pkiEnabled": false,
              "configId": "$configId",
              "hostName": "$hostName",
              "bootStrapId": "",
              "sudiRequired": false,
              "deviceDiscoveryInfo": {
                "timeout": 0,
                "userNameList": [
                  "$discoveryUser"
                ],
                "passwordList": [
                  "$discoveryPassword"
                ],
                "snmpMode": "",
                "discoveryType": "",
                "ipAddressList": "",
                "cdpLevel": 0,
                "enablePasswordList": [
                  ""
                ],
                "ipFilterList": [
                  ""
                ],
                "protocolOrder": "",
                "reDiscovery": false,
                "retry": 0,
                "snmpAuthPassphrase": "",
                "snmpAuthProtocol": "",
                "snmpPrivPassphrase": "",
                "snmpPrivProtocol": "",
                "snmpROCommunity": "",
                "snmpRWCommunity": "",
                "snmpUserName": "",
                "snmpVersion": "",
                "globalCredentialIdList": [
                  ""
                ],
                "name": ""
              },
              "licenseLevel": "",
              "eulaAccepted": false,
              "connectedToDeviceId": "",
              "connectedToPortId": "",
              "tag": "",
              "id": "",
              "platformId": "$platformId",
              "imageId": "",
              "aliases": [
                ""
              ],
              "templateConfigId": "",
              "licenseString": "",
              "apCount": "",
              "isMobilityController": "",
              "site": "",
              "configPreference": "",
              "imagePreference": "",
              "connectedToDeviceHostName": "",
              "connectedToPortName": "",
              "connetedToLocationCivicAddr": "",
              "connetedToLocationGeoAddr": ""
            }
          ]
"@
        $Uri = $connect.baseURL + "/pnp-project/" + $projectid + "/device"
    }
    Process {
        Write-Verbose $jsonbody
        $response = Invoke-Handeler -Uri $Uri -Method Post -Headers $connect.Headers -Body $jsonbody
        return $response.response
    }
}