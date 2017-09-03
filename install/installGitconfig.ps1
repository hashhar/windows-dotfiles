# Install my git config file.
if (!(Test-Path -Path "$env:HOME\.config")) {
    New-Item -ItemType directory -Path "$env:HOME\.config"
}

Copy-Item -Force -Recurse .\git "$env:HOME\.config\"
