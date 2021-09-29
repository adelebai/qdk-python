# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.

<#
    .SYNOPSIS
        Bootstrap: set up a Python environment using Anaconda
#>

param(
  [string] $PackageDir,
  [string] $EnvSuffix
)

# Set env vars
& (Join-Path (Join-Path $PSScriptRoot "build") "set-env.ps1");

# Import Conda utils
Import-Module (Join-Path (Join-Path $PSScriptRoot "build") "conda-utils.psm1");

# Enable conda hook
Enable-Conda

# Create environment
& (Join-Path (Join-Path $PSScriptRoot build) create-env.ps1) -PackageDir $PackageDir -EnvSuffix $EnvSuffix
