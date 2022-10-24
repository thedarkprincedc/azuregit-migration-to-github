param(
    $username = $env:GITHUB_USERNAME,
    $pat = $env:GITHUB_PAT,
    $accessToken,
    $destinationDir = "repos",
    $destinationRepoGit = $env:GITHUB_DESTINATION_REPO
)

$repositories = ./get-azure-repos.ps1
. ./common/common.ps1

if(!$accessToken){
    $accessToken = convertGithubPatToAccessToken -username $username -githubPersonalAccessToken $pat
}

New-Item -ItemType Directory -Force -Path $destinationDir
Push-Location -Path $destinationDir -StackName "repostack"

foreach($repository in ($repositories -Split ',')[0]){
    $projectName = $repository.Split('/')[-1]
    createPersonalRepository -accessToken $accessToken -projectName $projectName
    $results += migrateRepGit -repositoryUrl $repository -destinationRepoGit $destinationRepoGit
}

Pop-Location -StackName "repostack"
Write-Output $results;