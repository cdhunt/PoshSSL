Describe 'ConvertTo-X509Certificate' {
    BeforeAll {
        Import-Module "$PSScriptRoot/../publish/PoshSSL" -Force
    }
    AfterAll {
        Remove-Module PoshSSL
    }

    Context 'Base64 PEM' {

        It 'Should return an object for a PEM file' {
            $result = ConvertTo-X509Certificate -Path "$PSScriptRoot/DigiCertEVRSACAG2.pem"

            $result | Should -BeOfType Security.Cryptography.X509Certificates.X509Certificate2
            $result.Subject | Should -Be 'CN=DigiCert EV RSA CA G2, O=DigiCert Inc, C=US'
        }
    }

    Context 'DER Encoding' {
        $result = ConvertTo-X509Certificate -Path "$PSScriptRoot/gdg2.cer"

        $result | Should -BeOfType Security.Cryptography.X509Certificates.X509Certificate2
        $result.Subject | Should -Be 'CN=Go Daddy Secure Certificate Authority - G2, OU=http://certs.godaddy.com/repository/, O="GoDaddy.com, Inc.", L=Scottsdale, S=Arizona, C=US'
    }
}