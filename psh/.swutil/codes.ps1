Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($env:SRC_ROOT)) {
    $script:SrcRoot = Join-Path $HOME "src"
}
else {
    $script:SrcRoot = $env:SRC_ROOT
}

$script:ProjectDevlog = "devlog"
$script:ProjectsAll = @(
    "devlog"
)

function Invoke-Launch {
    param([string]$Project)

    if ([string]::IsNullOrWhiteSpace($Project)) {
        return
    }

    $path = Join-Path $script:SrcRoot $Project
    Write-Output "launch path: $path"

    if (-not (Test-Path -Path $path -PathType Container)) {
        Write-Output "$path is NOT existed"
        return
    }

    & code $path
}

function Invoke-LaunchAll {
    param([string[]]$Projects)

    if ($null -eq $Projects) {
        Write-Output "projects is NOT array"
        return
    }

    if ($Projects.Count -eq 0) {
        Write-Output "projects is empty"
        return
    }

    foreach ($project in $Projects) {
        Invoke-Launch -Project $project
    }
}

function Show-Help {
    $scriptName = $MyInvocation.ScriptName
    if ([string]::IsNullOrWhiteSpace($scriptName)) {
        $scriptName = "codes.ps1"
    }
    else {
        $scriptName = Split-Path -Leaf $scriptName
    }

    @"
$scriptName Usage: [SRC_ROOT=/path/to/source/root] $scriptName <target>
    all
    devlog
"@ | Write-Output
}

function Invoke-Main {
    param([string]$Target)

    switch ($Target) {
        "all" { Invoke-LaunchAll -Projects $script:ProjectsAll }
        "devlog" { Invoke-Launch -Project $script:ProjectDevlog }
        default { Show-Help }
    }
}

$target = if ($args.Count -gt 0) { $args[0] } else { $null }
Invoke-Main -Target $target
