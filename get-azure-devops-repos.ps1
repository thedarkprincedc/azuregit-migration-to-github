param(
    [string]$pat = $env:AZ_DEVOPS_PAT,
    [string]$organization = $env:AZ_DEVOPS_ORGANIZATION,
    [string]$project = $env:AZ_DEVOPS_PROJECT,
    [string]$format = "csv"
)

. ./common/common.ps1

$authToken = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($pat)"))
$request = getAzureRepositories -organization $organization -project $project -authToken $authToken

switch($format){
    "csv" { format-elements-as-csv -objects $request; break; }
    "list" { format-elements-as-list -objects $request; break; }
}

