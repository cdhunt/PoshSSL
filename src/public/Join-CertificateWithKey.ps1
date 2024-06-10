<#
.SYNOPSIS
    Join a Certificate and Private Key and export to a PFX file.
.DESCRIPTION
    Join a Certificate and Private Key and export to a PFX file.
.PARAMETER Certificate
    The path to a certificate file.
.PARAMETER PrivateKey
    The path to a PEM encoded private key file.
.PARAMETER IntermediaryCertificate
    The patth to one or more Intermediary Certificates to include in the PFX bundle.
.PARAMETER Password
    The password to protect the PFX file.
.PARAMETER PassThru
    Optionally send the X509Certificate2 object to the pipeline.
.NOTES
    The PFX file will be saved to the same directory as `$Certificate`.
.LINK
    New-CertificateSigningRequest
.EXAMPLE
    Join-CertificateWithKey -Certificate .\mynew.cer -PrivateKey .\mynew.key -Password (Get-Credential).Password

    Join CA signed certificate with issuing private key and export to a PFX file.
#>
function Join-CertificateWithKey {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0, ValueFromPipeline , ValueFromPipelineByPropertyName )]
        [Alias('PSPath')]
        [string]
        $Certificate,

        [Parameter(Mandatory , Position = 1, ValueFromPipelineByPropertyName)]
        [string]
        $PrivateKey,

        [Parameter(Position = 2)]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $IntermediaryCertificate,

        [Parameter(Position = 3)]
        [securestring]
        $Password = $null,

        [Parameter()]
        [switch]
        $PassThru
    )

    process {

        $certPath = Get-Item -Path $Certificate
        $newCert = [Security.Cryptography.X509Certificates.X509Certificate2]::New($certPath.FullName)
        $cn = $newCert.GetNameInfo([Security.Cryptography.X509Certificates.X509NameType]::SimpleName, $false)

        $pemKey = Get-Content $PrivateKey -Raw
        $pk = [System.Security.Cryptography.RSA]::Create()
        $pk.ImportFromPem($pemKey)

        $newCert = [Security.Cryptography.X509Certificates.RSACertificateExtensions]::CopyWithPrivateKey($newCert, $pk)

        $collection = [Security.Cryptography.X509Certificates.X509Certificate2Collection]::new($newCert)

        if ($PSBoundParameters.ContainsKey('IntermediaryCertificate')) {
            foreach ($i in $IntermediaryCertificate.Where({ Test-Path -Path $_ })) {
                $additionalCert = [Security.Cryptography.X509Certificates.X509Certificate2]::New($i)
                $index = $collection.Add($additionalCert)
                Write-Verbose "Including '$($additionalCert.Subject)'. Collection now contains $($index + 1) certs."
            }
        }

        $fileBaseName = ScrubCommonName -CommonName $cn
        $pfxFile = Join-Path -Path $certPath.Directory.FullName -ChildPath "$fileBaseName.pfx"

        [System.IO.File]::WriteAllBytes($pfxFile, $($collection.Export([Security.Cryptography.X509Certificates.X509ContentType]::Pkcs12, ($Password | ConvertFrom-SecureString -AsPlainText))))
        Write-Verbose "Saved PFX file as $pfxFile."

        if ($PassThru) {
            $collection | Write-Output
        }
    }

}