# ConvertTo-X509Certificate

Creates a new instance of the X509Certificate2 class using a certificate file name, a password.

## Parameters

### Parameter Set 1

- `[String]` **Path** _The name of a certificate file._ Mandatory, ValueFromPipeline
- `[SecureString]` **Password** _The password required to access the X.509 certificate data for protected file types._ 

## Examples

### Example 1

Converts a simple Base64 encoded PEM file to an X509Certificate2 object.

```powershell
ConvertTo-X509Certificate -Path .\fpca.pem
Thumbprint                                Subject              EnhancedKeyUsageList
----------                                -------              --------------------
37A1F0B26AAA46A837AD97D53ED78EF728B551D9  CN=freedompay-DC01-…
```
### Example 2

Converts a password protect PFX file to an X509Certificate2 object.

```powershell
$pfx = Get-Credential pfx
ConvertTo-X509Certificate -Path .\testpfx.pfx -Password $pfx.Password
Thumbprint                                Subject              EnhancedKeyUsageList
----------                                -------              --------------------
01556C24AE39A34AF91EA1561293E0F3C4F226D9  CN=MerchantPortal.C… {Server Authentication, Client Authentication}
```
