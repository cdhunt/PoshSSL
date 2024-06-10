# Join-CertificateWithKey

Join a Certificate and Private Key and export to a PFX file.

## Parameters

### Parameter Set 1

- `[String]` **Certificate** _The path to a certificate file._ Mandatory, ValueFromPipeline
- `[String]` **PrivateKey** _The path to a PEM encoded private key file._ Mandatory
- `[String[]]` **IntermediaryCertificate** _The patth to one or more Intermediary Certificates to include in the PFX bundle._ 
- `[SecureString]` **Password** _The password to protect the PFX file._ 
- `[Switch]` **PassThru** _Optionally send the X509Certificate2 object to the pipeline._ 

## Examples

### Example 1

Join CA signed certificate with issuing private key and export to a PFX file.

```powershell
Join-CertificateWithKey -Certificate .\mynew.cer -PrivateKey .\mynew.key -Password (Get-Credential).Password
```

## Links

- [New-CertificateSigningRequest](New-CertificateSigningRequest.md)

## Notes

The PFX file will be saved to the same directory as `$Certificate`.
