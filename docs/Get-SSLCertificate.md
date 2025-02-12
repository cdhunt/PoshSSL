# Get-SSLCertificate

Open an SSL connection to the given host and read the presented server certificate.

## Parameters

### Parameter Set 1

- `[String]` **ComputerName** _A hostname or Url of the server to retreive the certificate._ Mandatory, ValueFromPipeline
- `[Int32]` **Port** _The port to connect to the remote server._ 
- `[Switch]` **SslProtocol** _The SslProtocols value that represents protocols used for authentication.
The Default is None (Allows the operating system to choose the best protocol to use, and to block protocols that are not secure)._ 
- `[X509Certificate[]]` **ClientCertificate** _A client certificate used for mTLS._ 
- `[Switch]` **CheckCertificateRevocation** _Check the certificate revocation list._ 
- `[String]` **OutSslStreamVariable** _Stores SslStream connetion details from the command in the specified variable._ 

## Examples

### Example 1

Return the certificate for google.com.

```powershell
Get-SSLCertificate google.com
Thumbprint                                Subject              EnhancedKeyUsageList
----------                                -------              --------------------
9B97772CC2C860B0D0663AD3ED34272FF927EDEE  CN=*.google.com      Server Authentication
```
### Example 2

Verify a server certificate. You can use Test-SSLCertificate to validate the entire certificate chain.

```powershell
$cert = Get-SSLCertificate expired.badssl.com
$cert.Verify()
False
```
### Example 3

Write SslStream connection details to Verbose stream.

```powershell
$cert = Get-SSLCertificate google.com -verbose
VERBOSE: Converting Uri to host string
VERBOSE: ComputerName = google.com
VERBOSE: Cipher: Aes256 strength 256
VERBOSE: Hash: Sha384 strength 0
VERBOSE: Key exchange: None strength 0
VERBOSE: Protocol: Tls13
```
### Example 4

Stores SslStream connection details in the `$sslStreamValue` variable.

```powershell
Get-SSLCertificate -ComputerName 'google.com' -OutSslStreamVariable sslStreamValue
Thumbprint                                Subject              EnhancedKeyUsageList
----------                                -------              --------------------
5D3AD94714B07830A1BFB445F6F581AD0AC77689  CN=*.google.com      Server Authentication
$sslStreamValue
CipherAlgorithm      : Aes256
CipherStrength       : 256
HashAlgorithm        : Sha384
HashStrength         : 0
KeyExchangeAlgorithm : None
KeyExchangeStrength  : 0
SslProtocol          : Tls13
```
### Example 5



```powershell
Get-SSLCertificate -ComputerName 'google.com' -OutSslStreamVariable sslStreamValue -SslProtocol tls12
...
$sslStreamValue
...
SslProtocol          : Tls12
```

## Links

- [Test-SSLCertificate](Test-SSLCertificate.md)

## Notes

No validation check done. This command will trust all certificates presented.

## Outputs

- `System.Security.Cryptography.X509Certificates.X509Certificate2`
