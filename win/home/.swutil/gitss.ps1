# PowerShell 스크립트 에러 발생 시 즉시 중단 설정 (Bash의 set -e 기능)
$ErrorActionPreference = "Stop"

# 스크립트 경로 및 정보 조회 (Bash의 readlink, dirname, basename 대응)
$REAL_PATH = $MyInvocation.MyCommand.Path
$SCRIPT_DIR = Split-Path -Parent $REAL_PATH
$SCRIPT_NAME = Split-Path -Leaf $REAL_PATH

# 환경변수 SRC_PATH가 없으면 기본값인 $HOME/src/ss 사용 (Bash의 : ${SRC_PATH:=...} 대응)
if (-not $env:SRC_PATH) {
    $env:SRC_PATH = "D:\src\ss"
}

# 상수 정의
$SAS_REPOS_PREFIX = "ssh://git@githubm.com"
$PROJECT_TEST = "test"


# 프로젝트 배열 정의
$projects = @(
    $PROJECT_TEST
)

function git_clone {
    param([string]$project)

    if ([string]::IsNullOrEmpty($project)) {
        return 127
    }

    $path = Join-Path $env:SRC_PATH $project
    if (Test-Path $path) {
        Write-Output "$path is already existed"
        return 127
    }

    # URL 생성 시 슬래시(/) 방향 보존을 위해 직접 문자열 조인
    $repo = "${SAS_REPOS_PREFIX}/${project}"
    Write-Output "## git clone $repo"

    git clone $repo $path
}

function git_pull {
    param([string]$project)

    if ([string]::IsNullOrEmpty($project)) {
        return 127
    }

    $path = Join-Path $env:SRC_PATH $project
    Write-Output ""
    Write-Output "## git pull $path"
    
    if (-not (Test-Path $path)) {
        Write-Output "invalid path"
        return 127
    }

    # 임시 디렉토리 이동을 위해 Push/Pop 명령어 사용 (스크립트 흐름 오염 방지)
    Push-Location $path
    git pull
    Pop-Location
}

function git_push {
    param([string]$project)

    if ([string]::IsNullOrEmpty($project)) {
        return 127
    }

    $path = Join-Path $env:SRC_PATH $project
    Write-Output ""
    Write-Output "## git push $path"
    
    if (-not (Test-Path $path)) {
        Write-Output "invalid path"
        return 127
    }

    Push-Location $path
    git add .
    # RFC3339 시간 포맷팅에 맞춰 커밋 메시지 생성
    $commitDate = (Get-Date).ToString("yyyy-MM-ddTHH:mm:sszzz")
    git commit -m "$commitDate"
    git push
    Pop-Location
}

function clone_all {
    foreach ($project in $projects) {
        try { git_clone $project } catch { }
    }
}

function pull_all {
    foreach ($path in $projects) {
        try { git_pull $path } catch { }
    }
}

function push_all {
    foreach ($path in $projects) {
        try { git_push $path } catch { }
    }
}

function Show-Help {
    Write-Output @"
Usage: 
    `$env:SRC_PATH='/path/to/source/root'; .\$SCRIPT_NAME clone
    .\$SCRIPT_NAME push
    .\$SCRIPT_NAME pull
"@
}

function _main {
    # 첫 번째 인자가 비어있으면 "empty" 할당
    $arg = if ($args[0]) { $args[0] } else { "empty" }
    
    switch ($arg) {
        "clone" { clone_all }
        "push"  { push_all }
        "pull"  { pull_all }
        default { Show-Help }
    }
}

# 스크립트로 들어온 모든 매개변수 집합($args)을 메인 함수로 전달
_main $args
