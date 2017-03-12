function Add-To-Path($path) {
    if ($path.Length -eq 0) {
        return
    }
    foreach ($item in $env:Path.Split(';')) {
        if ($item.TrimEnd('\').Equals($path.TrimEnd('\'))) {
            Write-Output "Already in PATH."
            break
        }
    }
    $env:Path = $env:Path.Insert(0, $path + ";")
}

function Use-SSH () {
    $sshPath = $env:ProgramFiles + "\Git\usr\bin"
    Add-To-Path($sshPath)
    Start-SshAgent
    # Replace the keyname with the keys you want to add.
    ssh-add "$env:HOME\.ssh\id_rsa_github"
    # Uncomment below lines to add all keys on startup (is irritating).
    # $keys = Get-ChildItem -Path "$env:HOME\.ssh\" -Filter "*.pub"
    # foreach ($key in $keys) {
    #     ssh-add $key.FullName.TrimEnd(".pub")
    # }
}

function Use-SystemPython () {
    $pythonPath = $env:HOMEDRIVE + "\Python27"
    $pythonScriptPath = $pythonPath + "\Scripts"
    Add-To-Path($pythonPath)
    Add-To-Path($pythonScriptPath)
    $env:PYTHON = $pythonPath + "\python.exe"
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
