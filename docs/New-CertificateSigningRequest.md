# New-CertificateSigningRequest

Create a new Certificate Signing Request with EnhancedKeyUsages of "Server Authentication" and "Client Authentication".

## Parameters

### Parameter Set 1

- `[String]` **CommonName** _The CommonName for the certificate SubjectName._ Mandatory
- `[String]` **Organization** _The Organization (O) for the certificate SubjectName._ 
- `[String]` **OrganizationalUnit** _The OrganizationalUnit (OU) for the certificate SubjectName._ 
- `[String]` **Locality** _The Locality (L) for the certificate SubjectName._ 
- `[String]` **State** _The State (S) or ProvinceName for the certificate SubjectName._ 
- `[String]` **CountryCode** _The CountryCode (C) or Region for the certificate SubjectName._ 
- `[String[]]` **SubjectAlternativeNames** _A list of SAN DNS Names._ 
- `[Int32]` **RSAKeyLength** _Generate and use an RSA key pair of this size for the certificate._ 
- `[String]` **Path** _A directory path to store the Key and CSR PEM files. Default is the current directory._ 
- `[Switch]` **PassThru** _Optionally send the CSR PEM content to the pipeline._ 

### Parameter Set 2

- `[String]` **CommonName** _The CommonName for the certificate SubjectName._ Mandatory
- `[String]` **Organization** _The Organization (O) for the certificate SubjectName._ 
- `[String]` **OrganizationalUnit** _The OrganizationalUnit (OU) for the certificate SubjectName._ 
- `[String]` **Locality** _The Locality (L) for the certificate SubjectName._ 
- `[String]` **State** _The State (S) or ProvinceName for the certificate SubjectName._ 
- `[String]` **CountryCode** _The CountryCode (C) or Region for the certificate SubjectName._ 
- `[String[]]` **SubjectAlternativeNames** _A list of SAN DNS Names._ 
- `[Switch]` **ECDSAKey** _Generate and use an ECDSA key pair for the certifice. Not yet implemented._ 
- `[String]` **Path** _A directory path to store the Key and CSR PEM files. Default is the current directory._ 
- `[Switch]` **PassThru** _Optionally send the CSR PEM content to the pipeline._ 

## Links

- [Join-CertificateWithKey](Join-CertificateWithKey.md)

## Notes

This command will write a `.csr` and `.key` file to `$Path`.
The Key is not encrypted. Ensure it is stored in a secure location.

## Outputs

- `string`
