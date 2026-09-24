# 파라미터 변수는 선언된 곳의 스코프에 자동으로 만들어짐. 스크립트의 param()이면 스크립트 스코프, 함수의 param()이면 함수 스코프
# param() 변수는 스크립트 스코프에 생성되므로 $script:Target, $script:SrcRoot 로 액세스 가능
# (선언에는 스코프를 붙이지 않음 - $script:X 로 선언하면 파라미터 이름이 'script:X'가 되어 -X 로 전달 불가)
param(
    [Parameter(Position = 0)]
    [string]$Target,

    # 미지정 시 $env:SRC_ROOT, 그것도 없으면 ~/src 사용
    [string]$SrcRoot
)

# PowerShell 스크립트 에러 발생 시 즉시 중단 설정 (Bash의 set -e 기능)
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# 스크립트 경로 및 정보 조회 (Bash의 readlink, dirname, basename 대응)
$script:SCRIPT_PATH = $MyInvocation.MyCommand.Path
$script:SCRIPT_DIR = Split-Path -Parent $SCRIPT_PATH
$script:SCRIPT_NAME = Split-Path -Leaf $SCRIPT_PATH

if ([string]::IsNullOrWhiteSpace($script:SrcRoot)) {
    if ([string]::IsNullOrWhiteSpace($env:SRC_ROOT)) {
        $script:SrcRoot = Join-Path $HOME "src"
    }
    else {
        $script:SrcRoot = $env:SRC_ROOT
    }
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
    @"
Usage: $script:SCRIPT_NAME [-SrcRoot <path>] <target>
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

Invoke-Main -Target $Target
