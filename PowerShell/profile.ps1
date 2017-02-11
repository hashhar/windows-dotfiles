function Add-To-Path($path) {
    $pathSplit = $env:Path.Split(';')
    foreach ($item in $pathSplit) {
        if ($item.TrimEnd('\').Equals($path.TrimEnd('\'))) {
            Write-Output "Already in PATH."
            break
        }
    }
    $env:Path.Insert(0, $path)
}

function Use-SSH () {
    $sshPath = $env:ProgramFiles + "\Git\usr\bin"
    Add-To-Path($sshPath)
    Start-SshAgent
}

function Use-SystemPython () {
    $pythonPath = $env:HOMEDRIVE + "\Python27"
    $pythonScriptPath = $pythonPath + "\Scripts"
    Add-To-Path($pythonPath)
    Add-To-Path($pythonScriptPath)
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
