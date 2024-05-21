using namespace Security.Cryptography.X509Certificates

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
.NOTES
    Information or caveats about the function e.g. 'This function is not supported in Linux'
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
        $Password = $null
    )

    begin {

    }

    process {

        $certPath = Get-Item -Path $Certificate
        $newCert = [X509Certificate2]::New($certPath.FullName)
        $cn = $newCert.GetNameInfo([X509NameType]::SimpleName, $false)

        $pemKey = Get-Content $PrivateKey -Raw
        $pk = [System.Security.Cryptography.RSA]::Create()
        $pk.ImportFromPem($pemKey)

        $newCert = [RSACertificateExtensions]::CopyWithPrivateKey($newCert, $pk)

        $fileBaseName = ScrubCommonName -CommonName $cn
        $pfxFile = Join-Path -Path $Path -ChildPath "$fileBaseName.pfx"

        [System.IO.File]::WriteAllBytes($pfxFile, $($newCert.Export([System.X509ContentType]::Pkcs12, $Password)))
    }

    end {

    }
}