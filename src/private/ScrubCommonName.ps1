function ScrubCommonName {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [string]
        $CommonName
    )

    process {
        $CommonName -replace '\.', '_' -replace '\*', 'WILDCARD' | Write-Output
    }

}