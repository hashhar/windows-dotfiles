# Install my git config file.
New-Item -ItemType "directory" "$env:HOME\.config"
Copy-Item -Recurse .\git "$env:HOME\.config\"
