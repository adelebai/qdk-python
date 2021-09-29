# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.

<#
    .SYNOPSIS
        Install: Install Python packages in Conda environments
        Optionally install from source or from PyPI
#>


param (
  [string[]] $PackageDirs,
  [string[]] $EnvNames,
  [bool] $FromSource
)

Write-Host "##[info]FromSource: '$FromSource'".

& (Join-Path $PSScriptRoot "set-env.ps1");

Import-Module (Join-Path $PSScriptRoot "conda-utils.psm1");

if ($null -eq $PackageDirs) {
  $ParentPath = Split-Path -parent $PSScriptRoot
  $PackageDirs = Get-ChildItem -Path $ParentPath -Recurse -Filter "environment.yml" | Select-Object -ExpandProperty Directory | Split-Path -Leaf
  Write-Host "##[info]No PackageDir. Setting to default '$PackageDirs'"
}

if ($null -eq $EnvNames) {
  $EnvNames = $PackageDirs | ForEach-Object {$_.replace("-", "")}
  Write-Host "##[info]No EnvNames. Setting to default '$EnvNames'"
} else {
  $EnvNames = $EnvNames | ForEach-Object {$_.replace("-", "")}
  Write-Host "##[info]Using EnvNames '$EnvNames'"
}

if ($null -eq $FromSource) {
  $FromSource = $True
  Write-Host "##[info]No FromSource. Setting to default '$FromSource'"
}

# Check that input is valid
if ($EnvNames.length -ne $PackageDirs.length) {
  throw "Cannot run build script: '$EnvNames' and '$PackageDirs' lengths don't match"
}

function Install-Package() {
  param(
    [string] $EnvName,
    [string] $PackageName
  )
  # Activate env
  Use-CondaEnv $EnvName
  # Install package
  if ($True -eq $FromSource) {
    $ParentPath = Split-Path -parent $PSScriptRoot
    $AbsPackageDir = Join-Path $ParentPath $PackageName
    Write-Host "##[info]Install package $AbsPackageDir in development mode for env $EnvName"
    pip install -e $AbsPackageDir
  } else {
    Write-Host "##[info]Install package $PackageName for env $EnvName"
    pip install $PackageName
  }
}

if ($Env:ENABLE_PYTHON -eq "false") {
  Write-Host "##vso[task.logissue type=warning;]Skipping installing Python packages. Env:ENABLE_PYTHON was set to 'false'."
} else {
  for ($i=0; $i -le $PackageDirs.length-1; $i++) {
    Install-Package -EnvName $EnvNames[$i] -PackageName $PackageDirs[$i]
  }
}