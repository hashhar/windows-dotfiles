# Install my git config file.
if (!(Test-Path -Path "$env:HOME\.config")) {
    New-Item -ItemType directory -Path "$env:HOME\.config"
}

if (!(Test-Path -Path "$env:HOME\.config\git")) {
    Copy-Item -Recurse .\git "$env:HOME\.config\"
}
else {
    Write-Host "It seems you already have an existing git configuration."
}
