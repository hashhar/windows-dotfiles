# Check if PowerShellGet is available.
if ($PSVersionTable.PSVersion.Major -lt 5) {
    Write-Warning "You do not have PowerShell 5 so we cannot proceed."
}

# Check the ExecutionPolicy.
$execPolicy = Get-ExecutionPolicy -Scope CurrentUser
$unrestricted = [Microsoft.PowerShell.ExecutionPolicy].GetEnumName(0)
$remoteSigned = [Microsoft.PowerShell.ExecutionPolicy].GetEnumName(1)
if ( -not (($execPolicy -eq $unrestricted) -or ($execPolicy -eq $remoteSigned))) {
    Write-Warning "Your ExecutionPolicy is not one of $unrestricted or $remoteSigned. We will try to change it."
    # Fix the problem.
    Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
}

# Check for git in PATH.
if ((Get-Command "git.exe" -ErrorAction SilentlyContinue) -eq $null) {
    Write-Warning "Unable to find git.exe in your PATH. Install git and try again."
    Break
}

# Everything good? Install posh-git first.
PowerShellGet\Install-Module posh-git -Scope CurrentUser

# Install my profile file.
Copy-Item .\PowerShell\profile.ps1 $profile.CurrentUserAllHosts
