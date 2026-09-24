# 파라미터 변수는 선언된 곳의 스코프에 자동으로 만들어짐. 스크립트의 param()이면 스크립트 스코프, 함수의 param()이면 함수 스코프
# param() 변수는 스크립트 스코프에 생성되므로 $script:Command, $script:SrcPath 로 액세스 가능
# (선언에는 스코프를 붙이지 않음 - $script:X 로 선언하면 파라미터 이름이 'script:X'가 되어 -X 로 전달 불가)
param(
    [Parameter(Position = 0)]
    [string]$Command,

    # 미지정 시 $env:SRC_PATH, 그것도 없으면 ~/src 사용
    [string]$SrcPath
)

# PowerShell 스크립트 에러 발생 시 즉시 중단 설정 (Bash의 set -e 기능)
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# 스크립트 경로 및 정보 조회 (Bash의 readlink, dirname, basename 대응)
$script:SCRIPT_PATH = $MyInvocation.MyCommand.Path
$script:SCRIPT_DIR = Split-Path -Parent $SCRIPT_PATH
$script:SCRIPT_NAME = Split-Path -Leaf $SCRIPT_PATH

if ([string]::IsNullOrWhiteSpace($script:SrcPath)) {
    if ([string]::IsNullOrWhiteSpace($env:SRC_PATH)) {
        $script:SrcPath = Join-Path $HOME "src"
    }
    else {
        $script:SrcPath = $env:SRC_PATH
    }
}

$script:ReposPrefix = "git@github.com:haeram27"
$script:Projects = @(
    "devlog"
    "dev-lang-sample"
    "shell-env"
    "spring-msa-vanila"
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
    @"
Usage: $script:SCRIPT_NAME [-SrcPath <path>] subcommand
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

Invoke-Main -Command $Command
