# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.

<#
    .SYNOPSIS
        Bootstrap: set up a Python environment using Anaconda
#>

param(
  [string[]] $PackageDirs,
  [string] $envName,
  [string] $EnvPath
)

& (Join-Path (Join-Path $PSScriptRoot "build") "set-env.ps1");

Import-Module (Join-Path (Join-Path $PSScriptRoot "build") "conda-utils.psm1");

# Enable conda hook
Enable-Conda

if ($null -ne $EnvPath) {

  # Create environment from path
  & (Join-Path (Join-Path $PSScriptRoot build) create-env.ps1) -EnvPath $EnvPath

} else {

  # Get default value for PackageDirs by searching for environment.yml files
  if ($null -eq $PackageDirs) {
    $PackageDirs = Get-ChildItem -Path $PSScriptRoot -Recurse -Filter "environment.yml" | Select-Object -ExpandProperty Directory | Split-Path -Leaf
    Write-Host "##[info]No PackageDir. Setting to default '$PackageDirs'"
  }

  foreach ($PackageDir in $PackageDirs) {
      # Check if environment already exists
      $EnvName = $PackageDir.replace("-", "")
      $EnvExists = conda env list | Select-String -Pattern "$EnvName " | Measure-Object | Select-Object -Exp Count
      # if it exists, skip creation
      if ($EnvExists -eq "1") {
          Write-Host "##[info]Skipping creating $EnvName; env already exists."
      } else {
          # if it doese not exist, create env
          & (Join-Path $PSScriptRoot build create-env.ps1) -PackageDirs $PackageDir
      }
  }
}
