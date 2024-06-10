<#
.SYNOPSIS
    Creates a new instance of the X509Certificate2 class using a certificate file name, a password.
.DESCRIPTION
    Creates a new instance of the X509Certificate2 class using a certificate file name, a password.
.PARAMETER Path
    The name of a certificate file.
.PARAMETER Password
    The password required to access the X.509 certificate data for protected file types.
.EXAMPLE
    ConvertTo-X509Certificate -Path .\fpca.pem
    Thumbprint                                Subject              EnhancedKeyUsageList
    ----------                                -------              --------------------
    37A1F0B26AAA46A837AD97D53ED78EF728B551D9  CN=freedompay-DC01-…

    Converts a simple Base64 encoded PEM file to an X509Certificate2 object.
.EXAMPLE
    $pfx = Get-Credential pfx
    ConvertTo-X509Certificate -Path .\testpfx.pfx -Password $pfx.Password
    Thumbprint                                Subject              EnhancedKeyUsageList
    ----------                                -------              --------------------
    01556C24AE39A34AF91EA1561293E0F3C4F226D9  CN=MerchantPortal.C… {Server Authentication, Client Authentication}

    Converts a password protect PFX file to an X509Certificate2 object.
#>
function ConvertTo-X509Certificate {
    [CmdletBinding()]
    [Alias('ConvertTo-Certificate')]
    param (
        [Parameter(Mandatory, Position = 0, ValueFromPipeline , ValueFromPipelineByPropertyName )]
        [Alias('PSPath')]
        [string]
        $Path,

        [Parameter(Position = 1)]
        [securestring]
        $Password
    )

    process {
        $certPath = Resolve-Path -Path $Path
        try {
            if ($PSBoundParameters.ContainsKey('Password')) {
                [Security.Cryptography.X509Certificates.X509Certificate2]::New($certPath.Path, $Password)
            } else {
                [Security.Cryptography.X509Certificates.X509Certificate2]::New($certPath.Path)
            }
        } catch [System.Security.Cryptography.CryptographicException] {
            $message = "Could not convert file at '{0}' to a x509Certificate2 object. {1}" -f $certPath.Path, $_.Exception.Message
            Write-Error -Message $message  -Exception $_.Exception
        }
    }
}