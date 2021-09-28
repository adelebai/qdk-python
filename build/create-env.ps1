# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.

<#
    .SYNOPSIS
        Create Conda environment(s) for given package directories
#>

param(
  [string[]] $PackageDirs,
  [string] $EnvPath
)

function New-Environment() {
  param(
    [string] $PackageDir,
    [string] $EnvPath
  )

  # Create conda environment
  if ($null -eq $EnvPath) {
    $parentPath = Split-Path -parent $PSScriptRoot
    $EnvPath = Join-Path $parentPath $PackageDir environment.yml
  }

  Write-Host "##[info]Build '$EnvPath' Conda environment"
  conda env create --quiet --file $EnvPath
}

if ($null -ne $EnvPath) {
  # Create new environment from path
  New-Environment -EnvPath $EnvPath
} else {

  # Create new environment from default environment.yml file in path
  if ($null -eq $PackageDirs) {
    $parentPath = Split-Path -parent $PSScriptRoot
    $PackageDirs = Get-ChildItem -Path $parentPath -Recurse -Filter "environment.yml" | Select-Object -ExpandProperty Directory | Split-Path -Leaf
    Write-Host "##[info]No PackageDir. Setting to default '$PackageDirs'"
  }

  foreach ($PackageDir in $PackageDirs) {
    New-Environment -PackageDir $PackageDir
  }

}
