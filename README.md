# PoshSSL

A PowerShell module for working with x509 Certificates.

## CI

![GitHub Workflow Status (with event)](https://img.shields.io/github/actions/workflow/status/cdhunt/PoshSSL/powershell.yml?style=flat&logo=github)
[![Testspace pass ratio](https://img.shields.io/testspace/pass-ratio/cdhunt/cdhunt%3APoshSSL/main)](https://cdhunt.testspace.com/projects/68108/spaces)
[![PowerShell Gallery](https://img.shields.io/powershellgallery/v/PoshSSL.svg?color=%235391FE&label=PowerShellGallery&logo=powershell&style=flat)](https://www.powershellgallery.com/packages/PoshSSL)

![Build history](https://buildstats.info/github/chart/cdhunt/PoshSSL?branch=main)

## Install

`Install-Module -Name PoshSSL` or `Install-PSResource -Name PoshSSL`

![PowerShell Gallery](https://img.shields.io/powershellgallery/dt/PoshSSL?color=%235391FE&style=flat)

## Docs

[Full Docs](docs)

## Usage

This module has two sets of functionality.

### Inspect

The `Get|Show|Test-SSLCertificate` cmdlets help you inspect an HTTPS endpoint and examine the presented certificate.

### Create

The [New-CertificateSigningRequest](docs/New-CertificateSigningRequest.md) and [Join-CertificateWithKey](docs/Join-CertificateWithKey.md) cmdlets can be used for a typical new certificate request process.
Only RSA keys are currently supported and Certificate Extensions are hardcoded.
