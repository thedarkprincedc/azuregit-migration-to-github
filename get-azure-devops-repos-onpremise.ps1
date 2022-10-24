param(
    [string]$pat = $env:AZ_DEVOPS_PAT,
    [string]$organization = $env:AZ_DEVOPS_ORGANIZATION,
    [string]$format = "csv"
)

. ./common/common.ps1

$authToken = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($pat)"))
$request = getAzureRepositoriesOnPremise -organization $organization -authToken $authToken

switch($format){
    "csv" { format-elements-as-csv -objects $request; break; }
    "list" { format-elements-as-list -objects $request; break; }
}
