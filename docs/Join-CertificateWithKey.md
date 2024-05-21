# Join-CertificateWithKey

Join a Certificate and Private Key and export to a PFX file.

## Parameters

### Parameter Set 1

- `[String]` **Certificate** _The path to a certificate file._ Mandatory, ValueFromPipeline
- `[String]` **PrivateKey** _The path to a PEM encoded private key file._ Mandatory
- `[SecureString]` **Password** _The password to protect the PFX file._ 

## Links

- [New-CertificateSigningRequest](New-CertificateSigningRequest.md)

## Notes

Information or caveats about the function e.g. 'This function is not supported in Linux'
