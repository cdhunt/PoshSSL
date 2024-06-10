Describe 'New-CertificateSigningRequest' {
    BeforeAll {
        . "$PSScriptRoot/../publish/PoshSSL/private/ScrubCommonName.ps1"
        . "$PSScriptRoot/../publish/PoshSSL/public/New-CertificateSigningRequest.ps1"
        $openSsl = Get-Command -Name openssl -CommandType Application

        function GetFullPath {
            Param(
                [string] $Path
            )
            $leaf = $Path -replace 'TestDrive:\\', ''
            $tempPath = Join-Path -Path (Get-PSDrive TestDrive).Root -ChildPath $leaf
            return $tempPath
        }
    }

    Context 'New SSL Certificate Request' {
        BeforeAll {
            $result = New-CertificateSigningRequest `
                -CommonName testcsr.example.com `
                -Organization PoshSSL `
                -OrganizationalUnit Pester `
                -Locality Cloud `
                -State HI `
                -CountryCode US `
                -SubjectAlternativeNames testcsr.example.com `
                -RSAKeyLength 2048 `
                -Path "TestDrive:" `
                -PassThru

            $csr = Get-Content "TestDrive:\testcsr_example_com.csr" -Raw
            $key = Get-Content "TestDrive:\testcsr_example_com.key" -Raw

            if ($null -ne $openSsl) {
                $verifyCSR = openssl req -text -noout -verify -in "$(GetFullPath 'TestDrive:\testcsr_example_com.csr')" *>&1
                $verifyKey = openssl rsa -in "$(GetFullPath 'TestDrive:\testcsr_example_com.key')" -check *>&1
            }
        }

        It 'Should PassThru PEM content' {
            $result | Should -Not -BeNullOrEmpty
            $result[0] | Should -Be '-'
        }

        It 'Should Generate a CSR File' {
            $csr | Should -Match '-----BEGIN CERTIFICATE REQUEST-----'
            $csr | Should -Match '-----END CERTIFICATE REQUEST-----'
        }

        It 'Should Generate an RSA Key File' {
            $key | Should -Match '-----BEGIN RSA PRIVATE KEY-----'
            $key | Should -Match '-----END RSA PRIVATE KEY-----'
        }

        It 'Should generate a valid CSR' -Skip:($null -eq $openSsl) {
            $verifyCSR[0] | Should -Be 'Certificate request self-signature verify OK'
        }

        It 'Subject should be "C=US, ST=HI, L=Cloud, OU=Pester, O=PoshSSL, CN=testcsr.example.com"' -Skip:($null -eq $openSsl) {
            $verifyCSR[4] | Should -Match 'Subject: [C= ]+US, [ST= ]+HI, [L= ]+Cloud, [OU= ]+Pester, [O= ]+PoshSSL, [CN= ]+testcsr\.example\.com'
        }

        It 'Should use rsaEncryption' -Skip:($null -eq $openSsl) {
            $verifyCSR[6] | Should -Be '            Public Key Algorithm: rsaEncryption'
        }

        It 'Should have Key Usage of "Digital Signature, Key Encipherment"' -Skip:($null -eq $openSsl) {
            $verifyCSR[31] | Should -Be '                    Digital Signature, Key Encipherment'
        }

        It 'Should have Extended Key Usage of "TLS Web Server Authentication, TLS Web Client Authentication"' -Skip:($null -eq $openSsl) {
            $verifyCSR[33] | Should -Be '                    TLS Web Server Authentication, TLS Web Client Authentication'
        }

        It 'Should have a SAN of "DNS:testcsr.example.com"' -Skip:($null -eq $openSsl) {
            $verifyCSR[35] | Should -Be '                    DNS:testcsr.example.com'
        }

        It 'Should use sha256WithRSAEncryption Signature' -Skip:($null -eq $openSsl) {
            $verifyCSR[38] | Should -Be '    Signature Algorithm: sha256WithRSAEncryption'
        }

        It 'Should generate a valid RSA Key' -Skip:($null -eq $openSsl) {

            $verifyKey | Should -Contain 'RSA key ok'

        }

    }
}
