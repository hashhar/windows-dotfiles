function Use-SSH () {
    $env:Path = $env:ProgramFiles + "\Git\usr\bin;" + $env:Path
    Start-SshAgent
}

function Use-SystemPython () {
    $env:Path = $env:HOMEDRIVE + "\Python27;" + $env:HOMEDRIVE + "\Python27\Scripts;" + $env:Path
    Write-Output "Using system Python2 now."
}

function global:prompt {
    $realLASTEXITCODE = $LASTEXITCODE
    Write-Host($pwd.ProviderPath) -nonewline
    Write-VcsStatus
    $global:LASTEXITCODE = $realLASTEXITCODE
    Write-Host
    return "> "
}

# Set up gitattributes and gitignore and GitHub aliases.
$github = "D:\GitHub"
$gitatt = $github + "\_ToUse\gitattributes"
$gitig = $github + "\_ToUse\gitignore"

Import-Module posh-git
