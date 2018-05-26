$JsonBody = @"
{
    "username" : "devnetuser",
    "password" : "Cisco123!"
}
"@
$URIaddress =  "https://sandboxapic.cisco.com/api/v1/ticket"
Invoke-RestMethod -Uri $URIaddress -ContentType 'application/json'-Method Post -Body $JsonBody
