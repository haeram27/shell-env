## =========================================================================
# Register Environment Variable
## =========================================================================

# 1. 대상 디렉토리 및 환경 변수 정의
$Vars = @(
    @{ Name = "GRADLE_HOME"; Path = "$HOME\.env\gradle\9.6.1" }
    @{ Name = "JAVA_HOME";   Path = "$HOME\.env\jdk\25.0.4" }
    @{ Name = "CLASSPATH";   Value = ".;%JAVA_HOME%\lib"; CheckPath = "$HOME\jdk\25.0.4" } # CLASSPATH는 디렉토리가 아니므로 JAVA_HOME 기준으로 체크
    @{ Name = "BCOMP_HOME";  Path = "C:\Program Files\Beyond Compare 4" }
    @{ Name = "VIM_HOME"; Path = "$HOME\AppData\Local\Programs\Vim" }    
)

# 2. 사용자 변수(User Environment Variables) 생성 및 등록
foreach ($Var in $Vars) {
    # 체크할 디렉토리 경로 결정
    $CheckPath = if ($Var.CheckPath) { $Var.CheckPath } else { $Var.Path }
    $Value = if ($Var.Value) { $Var.Value } else { $Var.Path }

    # 디렉토리가 존재하는지 확인
    if (Test-Path $CheckPath) {
        # [Environment]::SetEnvironmentVariable(변수명, 값, 대상)
        # 'User'를 지정하여 사용자 변수로 등록합니다.
        [Environment]::SetEnvironmentVariable($Var.Name, $Value, 'User')
        Write-Host "Created Variable: $($Var.Name) = $Value" -ForegroundColor Green
    } else {
        Write-Host "Skipped: Directory not found for $($Var.Name) ($CheckPath)" -ForegroundColor Yellow
    }
}

# 3. Path에 추가할 항목 정의
$PathEntries = @(
    "%VIM_HOME%"
    "%BCOMP_HOME%"
    "%JAVA_HOME%\bin"
    "%GRADLE_HOME%\bin"
)

# 현재 사용자의 오리지널 Path 값 가져오기
$CurrentPath = [Environment]::GetEnvironmentVariable('Path', 'User')
# 반점(;) 기준으로 분할하여 배열로 관리
$PathList = $CurrentPath -split ';' | Where-Object { $_ -ne "" }

# Path 추가 작업
$PathChanged = $false
foreach ($Entry in $PathEntries) {
    # 이미 Path에 등록되어 있는지 중복 검사
    if ($PathList -notcontains $Entry) {
        $PathList += $Entry
        $PathChanged = $true
        Write-Host "Added to Path: $Entry" -ForegroundColor Green
    } else {
        Write-Host "Already in Path: $Entry" -ForegroundColor Cyan
    }
}

# 4. 변경된 사항이 있다면 Path 변수 저장
if ($PathChanged) {
    $NewPath = $PathList -join ';'
    [Environment]::SetEnvironmentVariable('Path', $NewPath, 'User')
    Write-Host "Path updated successfully." -ForegroundColor Green
} else {
    Write-Host "No changes made to Path." -ForegroundColor White
}

Write-Host "`n* Please restart your PowerShell/Command Prompt to apply changes." -ForegroundColor Green
