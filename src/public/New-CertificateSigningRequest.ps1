<#
.SYNOPSIS
    Create a new Certificate Signing Request.
.DESCRIPTION
    Create a new Certificate Signing Request with EnhancedKeyUsages of "Server Authentication" and "Client Authentication".
.PARAMETER CommonName
    The CommonName for the certificate SubjectName.
.PARAMETER Organization
    The Organization (O) for the certificate SubjectName.
.PARAMETER OrganizationalUnit
    The OrganizationalUnit (OU) for the certificate SubjectName.
.PARAMETER Locality
    The Locality (L) for the certificate SubjectName.
.PARAMETER State
    The State (S) or ProvinceName for the certificate SubjectName.
.PARAMETER CountryCode
    The CountryCode (C) or Region for the certificate SubjectName.
.PARAMETER SubjectAlternativeNames
    A list of SAN DNS Names.
.PARAMETER RSAKeyLength
    Generate and use an RSA key pair of this size for the certificate.
.PARAMETER ECDSAKey
    Generate and use an ECDSA key pair for the certifice. Not yet implemented.
.PARAMETER Path
    A directory path to store the Key and CSR PEM files. Default is the current directory.
.PARAMETER PassThru
    Optionally send the CSR PEM content to the pipeline.
.NOTES
    This command will write a `.csr` and `.key` file to `$Path`.
    The Key is not encrypted. Ensure it is stored in a secure location.
.LINK
    Join-CertificateWithKey
#>
function New-CertificateSigningRequest {
    [CmdletBinding()]
    [OutputType('string')]
    [Alias('New-CSR')]
    param (
        [Parameter(Mandatory , Position = 0)]
        [Alias('CN')]
        [string]
        $CommonName,

        [Parameter(Position = 1)]
        [String]
        $Organization,

        [Parameter(Position = 2)]
        [Alias('OU')]
        [String]
        $OrganizationalUnit,

        [Parameter()]
        [Alias('L')]
        [string]
        $Locality,

        [Parameter()]
        [Alias('S', 'ProvinceName')]
        [string]
        $State,

        [Parameter()]
        [Alias('C', 'Region')]
        [string]
        $CountryCode,

        [Parameter()]
        [Alias('SAN')]
        [string[]]
        $SubjectAlternativeNames,

        [Parameter(ParameterSetName = 'RSA')]
        [ValidateSet(1024, 2048, 3072, 4096, 5120, 6144, 7168, 8192, 9216, 10240, 11264, 12288, 13312, 14336, 15360)]
        [int]
        $RSAKeyLength,

        [Parameter(ParameterSetName = 'ECDSA')]
        [switch]
        $ECDSAKey,

        [Parameter()]
        [string]
        $Path = $PWD.Path,

        [Parameter()]
        [switch]
        $PassThru
    )

    if ($ECDSAKey) {
        throw "ECDSA Key support is not yet implemented"
    }

    $privateKey = [System.Security.Cryptography.RSA]::Create($RSAKeyLength)
    $distinguishedNameBuilder = [System.Security.Cryptography.X509Certificates.X500DistinguishedNameBuilder]::new()

    switch ($PSBoundParameters.Keys) {
        'CommonName' { $distinguishedNameBuilder.AddCommonName($CommonName) }
        'Organization' { $distinguishedNameBuilder.AddOrganizationName($Organization) }
        'OrganizationalUnit' { $distinguishedNameBuilder.AddOrganizationalUnitName($OrganizationalUnit) }
        'Locality' { $distinguishedNameBuilder.AddLocalityName($Locality) }
        'State' { $distinguishedNameBuilder.AddStateOrProvinceName($State) }
        'CountryCode' { $distinguishedNameBuilder.AddCountryOrRegion($CountryCode) }
    }

    $dn = $distinguishedNameBuilder.Build()

    Write-Verbose $dn.Name

    $request = [System.Security.Cryptography.X509Certificates.CertificateRequest]::new(
        $dn,
        $privateKey,
        [System.Security.Cryptography.HashAlgorithmName]::SHA256,
        [System.Security.Cryptography.RSASignaturePadding]::Pkcs1
    )

    $request.CertificateExtensions.Add(
        [System.Security.Cryptography.X509Certificates.X509KeyUsageExtension]::new(
                    ([System.Security.Cryptography.X509Certificates.X509KeyUsageFlags]::DigitalSignature -bor [System.Security.Cryptography.X509Certificates.X509KeyUsageFlags]::KeyEncipherment),
            $true))

    $oids = [System.Security.Cryptography.OidCollection]::new()
    $oids.Add([System.Security.Cryptography.Oid]::new("1.3.6.1.5.5.7.3.1")) | Write-Debug # Server Authentication
    $oids.Add([System.Security.Cryptography.Oid]::new("1.3.6.1.5.5.7.3.2")) | Write-Debug # Client Authentication
    $enhancedKeyUsage = [System.Security.Cryptography.X509Certificates.X509EnhancedKeyUsageExtension]::new($oids, $false)

    $request.CertificateExtensions.Add($enhancedKeyUsage)

    if ($PSBoundParameters.ContainsKey('SubjectAlternativeNames')) {
        $sanBuilder = [System.Security.Cryptography.X509Certificates.SubjectAlternativeNameBuilder]::new()
        $SubjectAlternativeNames.ForEach({
                $sanBuilder.AddDnsName($_) })
    }
    $request.CertificateExtensions.Add(
        [System.Security.Cryptography.X509Certificates.X509Extension]::new($sanBuilder.Build(), $false))

    $request.CertificateExtensions.Add(
        [System.Security.Cryptography.X509Certificates.X509SubjectKeyIdentifierExtension]::new($request.PublicKey, $false))

    $fileBaseName = ScrubCommonName -CommonName $CommonName
    $keyFile = Join-Path -Path $Path -ChildPath "$fileBaseName.key"
    $csrFile = Join-Path -Path $Path -ChildPath "$fileBaseName.csr"

    $privateKey.ExportRSAPrivateKeyPem() | Set-Content -Path $keyFile -Encoding Ascii
    Write-Warning "'$keyFile' is not encrypted. Be sure to store this file in a secure location."

    $pem = $request.CreateSigningRequestPem()

    $pem | Set-Content -Path $csrFile -Encoding Ascii

    if ($PassThru) {
        $pem
    }
}