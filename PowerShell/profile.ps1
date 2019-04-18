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
    ssh-add "$env:HOME\.ssh\id_rsa"
    # Uncomment below lines to add all keys on startup (is irritating).
    # $keys = Get-ChildItem -Path "$env:HOME\.ssh\" -Filter "*.pub"
    # foreach ($key in $keys) {
    #     ssh-add $key.FullName.TrimEnd(".pub")
    # }
}

function Find-GitRepository {
    <#
    .SYNOPSIS
    Find Git repositories
    .DESCRIPTION
    Use this command to find Git repositories in the specified folder. It is assumed that you have the Git command line tools already installed.
    .PARAMETER Path
    The top level path to search.
    .INPUTS
    [string]
    .OUTPUTS
    [pscustomobject]
    #>

    [cmdletbinding()]
    Param(
        [Parameter(
            Position = 0,
            HelpMessage = "The top level path to search"
        )]
        [ValidateScript( {
                if (Test-Path $_) {
                    $True
                }
                else {
                    Throw "Cannot validate path $_"
                }
            })]
        [string]$Path = "."
    )

    Write-Verbose "[BEGIN  ] Starting: $($MyInvocation.Mycommand)"
    Write-Verbose "[PROCESS] Searching $(Convert-Path -path $path) for Git repositories"
    $cwd = Get-Location

    Get-ChildItem -path $Path -Hidden -filter .git -Recurse |
        Select-Object @{Name = "Repository"; Expression = {Convert-Path $_.PSParentPath}},
    @{Name = "Branch"; Expression = {
            #save current location
            Push-Location
            #change location to the repository
            Set-Location -Path (Convert-Path -path ($_.psparentPath))
            #get current branch with out the leading asterisk
            # (git branch).where( {$_ -match "\*"}).Substring(2)
            # Use posh-git's util functions
            Get-GitBranch
        }
    },
    @{Name = "Remote"; Expression = {
            $remotes = Read-GitRemotesWithUrl .git/config
            foreach ($remote in $remotes.Keys) {
                if ($remote.Equals("NO_SECTION")) {
                    continue
                }
                $remotes[$remote]['url']
            }
            #change back to original location
            Pop-Location
        }
    }

    Write-Verbose "[END    ] Ending: $($MyInvocation.Mycommand)"
    Set-Location $cwd

} #end function

Function Read-GitRemotesWithUrl ($file) {
    $ini = @{}

    # Create a default section if none exist in the file. Like a java prop file.
    $section = "NO_SECTION"
    $ini[$section] = @{}

    switch -regex -file $file {
        '^\[(remote "(.+)")\]$' {
            $section = $matches[2].Trim()
            $ini[$section] = @{}
        }
        "^\s*(url)\s*=\s*(.*)" {
            $name, $value = $matches[1..2]
            # skip comments that start with semicolon:
            if (!($name.StartsWith(";"))) {
                $ini[$section][$name] = $value.Trim()
            }
        }
    }
    $ini
}

Import-Module posh-git
$GitPromptSettings.DefaultPromptBeforeSuffix.Text = '`n'