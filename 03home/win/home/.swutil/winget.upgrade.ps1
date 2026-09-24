# 1. 현재 관리자 권한으로 실행 중인지 확인
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
isAdministrator = currentPrincipal.IsInRole([Security.Principal.WindowsRole]::Administrator)

if (-not $isAdministrator) {
    # 2. 관리자 권한이 아니라면 UAC 창을 띄우며 자기 자신을 관리자 권한으로 재실행
    Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"\$PSCommandPath`"" -Verb RunAs
    Exit
}

# 3. 관리자 권한 획득 후 WinGet 자동 업데이트 실행
Write-Host "WinGet 전체 자동 업데이트를 시작합니다..." -ForegroundColor Cyan

# --disable-interactivity 옵션으로 사용자 입력 요구를 원천 차단합니다.
winget upgrade --all --silent --disable-interactivity --accept-source-agreements --accept-package-agreements

Write-Host "`n모든 업데이트 프로세스가 완료되었습니다." -ForegroundColor Green
Write-Host "창을 닫으려면 아무 키나 누르세요..."
null = Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
