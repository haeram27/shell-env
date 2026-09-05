## =========================================================================
# 1. Administrator Privilege Check & Auto-Elevation
## =========================================================================
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "[Info] This script requires Administrator privileges." -ForegroundColor Yellow
    Write-Host "[Info] Relaunching in a new Administrator PowerShell window..." -ForegroundColor Cyan
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

## =========================================================================
# Environment Validation: Check Winget & Internet Connection
## =========================================================================
if (-not (Get-Command "winget" -ErrorAction SilentlyContinue)) {
    Write-Host "[Error] 'winget' is not installed on this system." -ForegroundColor Red
    Write-Host "[Tip] Please install 'App Installer' from the Microsoft Store first." -ForegroundColor Yellow
    Read-Host -Prompt "Press Enter to exit..."
    Exit
}

Write-Host "Checking internet connectivity..." -ForegroundColor Cyan
if (-not (Test-Connection -ComputerName 8.8.8.8 -Count 1 -Quiet)) {
    Write-Host "[Warning] Internet connection is unstable or disconnected." -ForegroundColor Yellow
    Write-Host "[Warning] The installation process might fail without network access." -ForegroundColor Yellow
}

## =========================================================================
# 2. Reset and Update Winget Source (Prevents Freezing/Hanging)
## =========================================================================
Write-Host "`n==========================================" -ForegroundColor Cyan
Write-Host "Initializing package manager (winget)..." -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

try {
    winget source reset --force | Out-Null
    winget source update | Out-Null
} catch {
    Write-Host "[Warning] Failed to update winget sources, but continuing anyway..." -ForegroundColor Yellow
}

## =========================================================================
# 3. Enable script execution for the current user safely
## =========================================================================
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

Write-Host "`n==========================================" -ForegroundColor Cyan
Write-Host "Starting installation of development tools..." -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

## =========================================================================
# 4. List of application IDs for winget
## =========================================================================
$apps = @(
    "Microsoft.PowerShell"
    "Git.Git"
    "vim.vim"
    "JanDeDobbeleer.OhMyPosh"
    "eza-community.eza"                  # ls like file list
    "sharkdp.fd"
    "junegunn.fzf"
    "sharkdp.bat"                        # improved cat
    "ajeetdsouza.zoxide"                 # change directory, use z or zi
    "GnuPG.Gpg4win"
    "Microsoft.PowerToys"
    "7zip.7zip"
    "Microsoft.VisualStudioCode"
    "Obsidian.Obsidian"
    "Notepad++.Notepad++"
    "GitHub.Copilot"
    "Anthropic.ClaudeCode"
    "Mozilla.Firefox"
    "Google.Chrome"
    "PDFsam.PDFsam"
    "ShareX.ShareX"
)


## =========================================================================
# 5. Standard Installation : Bcompare
## =========================================================================
Write-Host "`n==========================================" -ForegroundColor Cyan
Write-Host "Installing Beyond Compare 4 from Official Website..." -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

# 1. 다운로드 경로 및 파일명 정의
$url = "https://www.scootersoftware.com/files/BCompare-4.4.7.28397.exe"
$tempPath = "$env:TEMP\BCompare4_installer.exe"

# 2. 이미 설치되어 있는지 파일 경로로 체크 (C:\Program Files 기준)
$checkPath = "C:\Program Files\Beyond Compare 4\BComp.exe"

if (Test-Path $checkPath) {
    Write-Host "-> Beyond Compare 4 is already installed. Skipping." -ForegroundColor Green
} else {
    Write-Host "-> Downloading installer from official website..." -ForegroundColor Cyan
    
    # TLS 1.2 보안 프로토콜 강제 활성화 (다운로드 차단 방지)
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    
    # 파일 다운로드 진행
    Invoke-WebRequest -Uri $url -OutFile $tempPath -UserAgent "Mozilla/5.0"
    Write-Host "-> Download complete." -ForegroundColor Green
    
    Write-Host "-> Running silent installation..." -ForegroundColor Cyan
    # /VERYSILENT: 설치 창을 숨김, /NORESTART: 설치 후 시스템 재부팅 방지
    $installProcess = Start-Process -FilePath $tempPath -ArgumentList "/VERYSILENT /NORESTART" -Wait -PassThru
    
    # 3. 설치 완료 여부 최종 확인
    if ($installProcess.ExitCode -eq 0 -or (Test-Path $checkPath)) {
        Write-Host "-> Beyond Compare 4 has been successfully installed!" -ForegroundColor Green
    } else {
        Write-Host "-> [Warning] Installation finished, but verify with ExitCode: $($installProcess.ExitCode)" -ForegroundColor Yellow
    }
    
    # 임시 설치 파일 삭제 (정리)
    if (Test-Path $tempPath) { Remove-Item $tempPath -Force }
}

Write-Host "`n==========================================" -ForegroundColor Green
Write-Host "All installation processes are complete!" -ForegroundColor Green
Write-Host "To apply changes (e.g., PowerShell 7, oh-my-posh)," -ForegroundColor Yellow
Write-Host "please close this terminal completely and restart it." -ForegroundColor Yellow
Write-Host "==========================================" -ForegroundColor Green

## =========================================================================
# 6. Install module from PowerShell Gallary
## =========================================================================
# 1. TLS 1.2 보안 통과 프로토콜 활성화
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# 2. 누락되거나 손상된 PSGallery 저장소 강제 복구 및 재등록
Write-Host "-> Validating PowerShell Gallery repository..." -ForegroundColor Yellow
$psGallery = Get-PSRepository -Name "PSGallery" -ErrorAction SilentlyContinue
if (-not $psGallery) {
    Write-Host "-> PSGallery not found. Registering official PowerShell Gallery..." -ForegroundColor Cyan
    Register-PSRepository -Default -ErrorAction SilentlyContinue
}

Write-Host "`n==========================================" -ForegroundColor Cyan
Write-Host "Checking PowerShell Module: PSFzf" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
$psfzfInstalled = Get-Module -ListAvailable -Name PSFzf 2>$null

if ($psfzfInstalled) {
    Write-Host "-> PSFzf module is already installed. Skipping." -ForegroundColor Green
} else {
    Write-Host "-> PSFzf module not found. Starting installation..." -ForegroundColor Cyan

    # NuGet 공급자 사전 업데이트
    Get-PackageProvider -Name NuGet -ForceBootstrap | Out-Null

    # 복구된 저장소(PSGallery)를 통해 안전하게 모듈 설치
    Install-Module -Name PSFzf -Scope CurrentUser -Repository PSGallery -Force -SkipPublisherCheck
    
    # 설치 성공 여부 재확인
    if (Get-Module -ListAvailable -Name PSFzf 2>$null) {
        Write-Host "-> PSFzf module has been successfully installed!" -ForegroundColor Green
    } else {
        Write-Host "-> [Error] Installation failed. Please check your network or repository status." -ForegroundColor Red
    }
}


## Print All installed apps checked by winget
#Write-Host "`n[Summary] Displaying current Winget Installed List:" -ForegroundColor Cyan
#winget list --accept-source-agreements

## Keep the window open to check the final log
Read-Host -Prompt "Press Enter to exit"
