# Check the ExecutionPolicy.
$execPolicy = Get-ExecutionPolicy -Scope CurrentUser
$unrestricted = [Microsoft.PowerShell.ExecutionPolicy].GetEnumName(0)
$remoteSigned = [Microsoft.PowerShell.ExecutionPolicy].GetEnumName(1)
if ( -not (($execPolicy -eq $unrestricted) -or ($execPolicy -eq $remoteSigned))) {
    Write-Warning "Your ExecutionPolicy is not one of $unrestricted or $remoteSigned. We will try to change it."
    # Fix the problem.
    Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
}

# Install Windows PowerShell profiles.
.\install\installPSProfile.ps1
.\install\installGitconfig.ps1
