param(
    [Parameter(Mandatory=$true)]
    [string]$AZ_DEVOPS_PAT,
    [Parameter(Mandatory=$true)]
    [string]$AZ_ORGANIZATION,
    [Parameter(Mandatory=$true)]
    [string]$AZ_PROJECT
)


$env:AZ_DEVOPS_PAT = $AZ_DEVOPS_PAT
$env:AZ_ORGANIZATION = $AZ_ORGANIZATION
$env:AZ_PROJECT = $AZ_PROJECT
