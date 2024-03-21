$param1 = $args[0]

if ($param1 -eq "start") {
    Write-Host "Creating if not exists, and / or starting"
    devcontainer up --remote-env GIT_USER_NAME=$(git config user.name) --remote-env GIT_USER_EMAIL=$(git config user.email) --workspace-folder .
}
elseif ($param1 -eq "destructive") {
    Write-Host "Running destructive creation - former container will be destroyed and replaced, but volumes will be reused."
    devcontainer up --remote-env GIT_USER_NAME=$(git config user.name) --remote-env GIT_USER_EMAIL=$(git config user.email) --remove-existing-container --workspace-folder .
}
else {
    Write-Host "Error: Invalid parameter. Acceptable parameters are 'start', or 'destructive'."
}
