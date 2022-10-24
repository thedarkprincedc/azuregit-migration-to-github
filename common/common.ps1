function gitCloneRepository{
    param(
        [string]$repositoryUrl
    )
    git clone --mirror $repositoryUrl
    if (-not $?) {
        throw "Error with git clone!"
    }
}
function gitRemoteAdd {
    param(
        [string]$remoteName,
        [string]$destinationPath
    )
    git remote add $remoteName $destinationPath
    if (-not $?) {
        throw "Error with git remote!"
    }
}

function gitPush {
    param(
        [string]$remoteName
    )
    git push --mirror $remoteName
    if (-not $?) {
        throw "Error with git push!"
    }
}

function format-elements-as-csv{
    param(
        [object]$objects
    )
    $list = @()
    foreach($projectElement in $objects.value){
        $list += $projectElement.sshUrl
    }
    $list -join ', ';
}
function format-elements-as-list {
    param(
        [object]$objects
    )
    $list = @();
    foreach($projectElement in $objects.value){
        $list += $projectElement.sshUrl
    }
    $list
}

function convertAzureDevopsPatToAccessToken {
    param(
        [string]$azureDevopsPersonalAccessToken
    )
    [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($azureDevopsPersonalAccessToken)"))
}
function getAzureRepositories{
    param(
        [string]$organization,
        [string]$project,
        [string]$authToken
    )
    $url = "https://dev.azure.com/$organization/$project/_apis/git/repositories?api-version=4.1"
    $headers = @{Authorization = "Basic $authToken"}

    Invoke-RestMethod -Uri $url -Headers $headers
}

function getAzureRepositoriesOnPremise{
    param(
        [string]$baseurl,
        [string]$project,
        [string]$authToken
    )
    $url = "$baseurl/$project/_apis/git/repositories?api-version=5.1"
    $headers = @{Authorization = "Basic $authToken"}

    Invoke-RestMethod -Uri $url -Headers $headers
}

function createPersonalRepository{
    param(
        [string]$accessToken,
        [string]$projectName
    )
    $headers = @{ Authorization = "Basic $accessToken" }
    $method = "Post"
    $url = "https://api.github.com/user/repos"
    $body = ConvertTo-Json @{
        "name" = $projectName
    }
    $Response = Invoke-WebRequest -Method $method -Uri $url -Body $body -Headers $headers
    $Response
}
function createOrganizationRepository{
    param(
        [string]$accessToken,
        [string]$projectName,
        [string]$organization
    )
    $headers = @{ Authorization = "Basic $accessToken" }
    $method = "Post"
    $url = "https://api.github.com/orgs/$organization/repos"
    $body = ConvertTo-Json @{
        "name" = $projectName
        "description" = "This is your first repository"
        "homepage" = "https://github.com"
        "private" = false
        "has_issues" = true
        "has_projects" = true
        "has_wiki" = true
    }
    $Response = Invoke-WebRequest -Method $method -Uri $url -Body $body -Headers $headers
    $Response
}

function convertGithubPatToAccessToken {
    param(
        [string]$username,
        [string]$githubPersonalAccessToken
       
    )
    [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("$($username):$($githubPersonalAccessToken)"))
}


function migrateRepGit{
    param(
        [string]$repositoryUrl,
        [string]$destinationRepoGit
    )
    $remoteName = "migration-destination-repo"
    $projectName = $repositoryUrl.Split('/')[-1]
    $destinationPath = "$destinationRepoGit/$projectName.git"
    try{
        gitCloneRepository -repositoryUrl $repository
        Push-Location -Path "$projectName.git" -StackName "projectstack"
        gitRemoteAdd -destinationPath $destinationPath -remoteName $remoteName
        gitPush -remoteName $remoteName
        @{"$projectName" = @('success')}
    } catch {
        @{"$projectName" = $('error', "Message: $_")}
    } finally {
        Pop-Location -StackName "projectstack"
    }
}
