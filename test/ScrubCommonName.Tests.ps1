Describe 'ScrubCommonName' {
    BeforeAll {
        . "$PSScriptRoot/../publish/PoshSSL/private/ScrubCommonName.ps1"
    }

    Context 'Simple Names' {
        it 'Returns <expected> (<CommonName>)' -ForEach @(
            @{ CommonName = 'www.example.com'; Expected = 'www_example_com' }
            @{ CommonName = 'host-name.example.com'; Expected = 'host-name_example_com' }
        ) {
            ScrubCommonName -CommonName $CommonName | Should -Be $Expected
        }
    }

    Context 'Wildcard names' {
        it 'Returns <expected> (<CommonName>)' -ForEach @(
            @{ CommonName = '*.example.com'; Expected = 'wildcard_example_com' }
            @{ CommonName = '*.host-name.example.com'; Expected = 'wildcard_host-name_example_com' }
        ) {
            ScrubCommonName -CommonName $CommonName | Should -Be $Expected
        }
    }
}