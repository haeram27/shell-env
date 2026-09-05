Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($env:SRC_PATH)) {
    $script:SrcPath = Join-Path $HOME "src"
}
else {
    $script:SrcPath = $env:SRC_PATH
}

$script:ReposPrefix = "git@github.com:haeram27"
$script:Projects = @(
    "devlog"
    "shell-env"
)

function Invoke-GitClone {
    param([string]$Project)

    if ([string]::IsNullOrWhiteSpace($Project)) {
        return
    }

    $path = Join-Path $script:SrcPath $Project
    if (Test-Path -Path $path -PathType Container) {
        Write-Output "$path is already existed"
        return
    }

    $repo = "$($script:ReposPrefix)/$Project"
    Write-Output "## git clone $repo"
    & git clone $repo $path
}

function Invoke-GitPull {
    param([string]$Project)

    if ([string]::IsNullOrWhiteSpace($Project)) {
        return
    }

    $path = Join-Path $script:SrcPath $Project
    Write-Output ""
    Write-Output "## git pull $path"
    if (-not (Test-Path -Path $path -PathType Container)) {
        Write-Output "invalid path"
        return
    }

    Push-Location $path
    try {
        & git pull --recurse-submodules=yes --rebase=true --autostash
    }
    finally {
        Pop-Location
    }
}

function Invoke-GitPush {
    param([string]$Project)

    if ([string]::IsNullOrWhiteSpace($Project)) {
        return
    }

    $path = Join-Path $script:SrcPath $Project
    Write-Output ""
    Write-Output "## git push $path"
    if (-not (Test-Path -Path $path -PathType Container)) {
        Write-Output "invalid path"
        return
    }

    Push-Location $path
    try {
        & git add .
        if ($LASTEXITCODE -ne 0) { return }

        $message = Get-Date -Format "yyyy-MM-dd HH:mm:ssK"
        & git commit -m $message
        if ($LASTEXITCODE -ne 0) { return }

        & git push
    }
    finally {
        Pop-Location
    }
}

function Invoke-CloneAll {
    foreach ($project in $script:Projects) {
        Invoke-GitClone -Project $project
    }
}

function Invoke-PushAll {
    foreach ($project in $script:Projects) {
        Invoke-GitPush -Project $project
    }
}

function Invoke-PullAll {
    foreach ($project in $script:Projects) {
        Invoke-GitPull -Project $project
    }
}

function Show-Help {
    $scriptName = $MyInvocation.ScriptName
    if ([string]::IsNullOrWhiteSpace($scriptName)) {
        $scriptName = "gits.ps1"
    }
    else {
        $scriptName = Split-Path -Leaf $scriptName
    }

    @"
Usage: SRC_PATH=/path/to/source/root $scriptName pull
    clone
    push
    pull
"@ | Write-Output
}

function Invoke-Main {
    param([string]$Command)

    switch ($Command) {
        "clone" { Invoke-CloneAll }
        "push" { Invoke-PushAll }
        "pull" { Invoke-PullAll }
        default { Show-Help }
    }
}

$command = if ($args.Count -gt 0) { $args[0] } else { $null }
Invoke-Main -Command $command
