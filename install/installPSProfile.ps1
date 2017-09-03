# Check if PowerShellGet is available.
if ($PSVersionTable.PSVersion.Major -lt 5) {
    Write-Warning "You do not have PowerShell 5 so we cannot proceed."
}

# Check for git in PATH.
if ((Get-Command "git.exe" -ErrorAction SilentlyContinue) -eq $null) {
    Write-Warning "Unable to find git.exe in your PATH. Install git and try again."
    Break
}

if (Get-Module -ListAvailable -Name posh-git) {
    Write-Warning "posh-git is already installed."
}
else {
    # Everything good? Install posh-git first.
    PowerShellGet\Install-Module posh-git -Scope CurrentUser
}

# Install my profile file.
if (!(Test-Path -Path "$env:HOME\Documents\WindowsPowerShell\profile.ps1")) {
    Copy-Item .\PowerShell\profile.ps1 $profile.CurrentUserAllHosts
} else {
    Write-Host "It seems you already have a PowerShell profile configured."
}
