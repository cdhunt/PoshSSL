<#
.SYNOPSIS
    Join a Certificate and Private Key and export to a PFX file.
.DESCRIPTION
    Join a Certificate and Private Key and export to a PFX file.
.PARAMETER Certificate
    The path to a certificate file.
.PARAMETER PrivateKey
    The path to a PEM encoded private key file.
.PARAMETER Password
    The password to protect the PFX file.
.PARAMETER PassThru
    Optinoally send the CSR PEM content to the pipeline.
.NOTES
    The PFX file will be saved to the same directory as `$Certificate`.
.LINK
    New-CertificateSigningRequest
#>
function Join-CertificateWithKey {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0, ValueFromPipeline , ValueFromPipelineByPropertyName )]
        [Alias('PSPath')]
        [string]
        $Certificate,

        [Parameter(Mandatory , Position = 1)]
        [string]
        $PrivateKey,

        [Parameter(Position = 0)]
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

        $fileBaseName = ScrubCommonName -CommonName $cn
        $pfxFile = Join-Path -Path $certPath.Directory.FullName -ChildPath "$fileBaseName.pfx"

        [System.IO.File]::WriteAllBytes($pfxFile, $($newCert.Export([Security.Cryptography.X509Certificates.X509ContentType]::Pkcs12, $Password)))

        if ($PassThru) {
            $newCert | Write-Output
        }
    }

}