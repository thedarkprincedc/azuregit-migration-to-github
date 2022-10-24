param(
    [string]$username = $env:GITHUB_USERNAME,
    [string]$pat = $env:GITHUB_PAT,
    [string]$accessToken,
    [Parameter(Mandatory=$true)]
    [string]$projectName
)

. ./common/common.ps1

try {
    if(!$accessToken){
        if(!$username){
            throw "No Username found"
        }
        if(!$pat){
            throw "No Pat found"
        }
        $accessToken = convertGithubPatToAccessToken -username $username -githubPersonalAccessToken $pat
    }
    createPersonalRepository -accessToken $accessToken -projectName $projectName
} catch {
    Write-Output "Error: $_"
}

