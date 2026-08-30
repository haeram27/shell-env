# Path: ~\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
# Edit: vi $PROFILE
# UserHome: ~ or $env:USERPROFILE or %USERPROFILE%

########################################
# List all commands
########################################
# Get-Command
# Get-Command -CommandType Cmdlet
# Get-Command -CommandType Alias
# Get-Command -CommandType Function
# Get-Command -CommandType Application

########################################
# PSReadLine: key bindings and edit mode
########################################
# list of key bindings: Get-PSReadLineKeyHandler
# list of unbound keys: Get-PSReadLineKeyHandler -Unbound
Set-PSReadLineKeyHandler -Chord 'Ctrl+l' -Function AcceptSuggestion
Set-PSReadLineKeyHandler -Chord 'Ctrl+Alt+l' -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptSuggestion()
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
}
Set-PSReadLineKeyHandler -Chord 'Alt+f' -Function AcceptNextSuggestionWord
Set-PSReadLineKeyHandler -Chord 'Ctrl+u' -Function DeleteLine
Set-PSReadLineKeyHandler -Chord 'Ctrl+k' -Function KillLine
#Set-PSReadLineKeyHandler -Chord 'Ctrl+a' -Function BeginningOfLine

# Set-PSReadLineOption -EditMode Vi ## vi edit mode - ESC enables command mode, i enables insert mode
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle InlineView

########################################
# functions
########################################
# bat
function bats {
    bat -p --paging=never @args
}

# copilot
function Copilot-Auto {
    copilot --autopilot --yolo
}

# eza
function l  { eza --icons }
function ll { eza -la --git --icons }
function lt { eza --tree --level=2 --icons }


########################################
# alias
########################################
Set-Alias -Name which -Value where.exe
Set-Alias ls eza
Set-Alias vi vim
Set-Alias gvi gvim
Set-Alias cop.auto Copilot-Auto

########################################
# utils - init
########################################
# notepad++
$nppPath64 = "C:\Program Files\Notepad++\notepad++.exe"
if (Test-Path $nppPath64) {
    function npp { & "C:\Program Files\Notepad++\notepad++.exe" $args }
}

# zoxide
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
}

# PSFzf
<#
Import-Module PSFzf
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' `
                       -PSReadlineChordReverseHistory 'Ctrl+r' `
                       -PSReadlineChordChangeDirectory 'Alt+c'
#>
# fzf 프로그램 본체가 설치되어 있는지 확인
if (Get-Command fzf -ErrorAction SilentlyContinue) {
    Import-Module PSFzf

    # --------------------------------------------------
    # 1. fd 기반 검색 명령 정의 (환경 변수 설정)
    # --------------------------------------------------
    $env:FZF_DEFAULT_COMMAND = 'fd --type f --hidden --exclude .git'
    $env:FZF_CTRL_T_COMMAND  = $env:FZF_DEFAULT_COMMAND
    $env:FZF_ALT_C_COMMAND   = 'fd --type d --hidden --exclude .git'

    # --------------------------------------------------
    # 2. 글로벌 및 Ctrl+T 단축키 옵션 설정
    # --------------------------------------------------
    #$env:FZF_DEFAULT_OPTS = "-m --marker='▶ '"
    $env:FZF_CTRL_T_OPTS  = "-m --marker='▶ '"

    # --------------------------------------------------
    # 3. Alt+C 옵션 구성 (40% 높이, 레이아웃 역순, 트리 프리뷰)
    # --------------------------------------------------
    # 터미널용 최신 tree 도구(eza)가 있다면 사용, 없으면 내장 셸 명령어로 트리 구현
    if (Get-Command eza -ErrorAction SilentlyContinue) {
        $env:FZF_ALT_C_OPTS = "--height 40% --layout=reverse --preview 'eza --tree --level=3 --color=always {} | select -first 50'"
    } elseif (Get-Command tree -ErrorAction SilentlyContinue) {
        # Windows 기본 tree.com은 리눅스와 옵션이 달라 에러 방지차 plain 텍스트로 처리
        $env:FZF_ALT_C_OPTS = "--height 40% --layout=reverse --preview 'tree.com {}'"
    } else {
        # 별도 도구가 없는 경우 PowerShell 내장 명령어로 하위 폴더 구조 미리보기 구현
        $env:FZF_ALT_C_OPTS = "--height 40% --layout=reverse --preview 'Get-ChildItem -Path {} -Directory -Depth 2 | Select-Object -First 30 -ExpandProperty Name'"
    }

    # --------------------------------------------------
    # 4. 단축키 핸들러 최종 바인딩
    # --------------------------------------------------
    # Ctrl+T (파일 검색), Ctrl+R (히스토리)
    Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' `
                           -PSReadlineChordReverseHistory 'Ctrl+r'

    # Alt+C (디렉터리 전용 탐색 및 이동 강제)
    Set-PSReadLineKeyHandler -Key 'Alt+c' `
                             -BriefDescription 'Fuzzy Change Directory' `
                             -ScriptBlock { Invoke-FuzzySetLocation }

    # --------------------------------------------
    # 5. fzf 커스텀 유틸리티 기능
    # --------------------------------------------

    # ff: file을 찾아서 선택한 목록을 반환
    # syntax: ff /path/to/start
    function ff {
        param(
            [string]$Path = "." # 경로 생략 시 현재 디렉토리 기준
        )

        # 1. fd 명령어 존재 여부 확인
        $fdCmd = if (Get-Command fd -ErrorAction SilentlyContinue) { "fd" }
                 elseif (Get-Command fde -ErrorAction SilentlyContinue) { "fde" }
                 else { $null }

        # 2. bat 명령어 확인 및 미리보기 명령어 세팅
        $batCmd = if (Get-Command bat -ErrorAction SilentlyContinue) { "bat" } else { "type" }
        $previewCmd = if ($batCmd -eq "bat") {
            "bat --style=numbers --color=always --line-range :500 {}"
        } else {
            "type {}"
        }

        # 3. 파일 목록 생성 및 fzf 실행 (미리보기 및 다중 선택 포함)
        $files = if ($null -ne $fdCmd) {
            # fd가 있을 때: fd 목록 기반 검색 + 미리보기
            &$fdCmd --type file . $Path | fzf -m --marker='▶ ' --preview $previewCmd
        } else {
            # fd가 없을 때: 현재 위치를 이동하여 fzf 순정 검색 + 미리보기
            Push-Location $Path
            $result = fzf -m --marker='▶ ' --preview $previewCmd
            Pop-Location
            
            if ($result) {
                $result | ForEach-Object { Join-Path $Path $_ }
            } else {
                $null
            }
        }

        # 4. 사용자가 선택한 파일 리스트를 프롬프트에 나열
        if ($files) {
            foreach ($file in $files) {
                Write-Output $file
            }
        }
    }

    # fcd: fzf를 이용한 디렉터리 대화형 이동
    function fcd {
        # PSFzf 모듈의 기본 함수를 호출하여 폴더를 선택하고 즉시 cd(Set-Location) 합니다.
        Invoke-FuzzySetLocation
    }

    # fe: fzf로 파일을 찾아 Vim(또는 기본 에디터)으로 열기
    function fe {
        # Windows용 bat 프로그램(또는 batcat)으로 구문 강조 프리뷰 제공 (상위 500줄 제한)
        # bat가 설치되어 있지 않다면 프리뷰 옵션을 제외하고 실행됩니다.
        $previewCmd = if (Get-Command bat -ErrorAction SilentlyContinue) { "bat --style=numbers --color=always --line-range :500 {}" } else { "type {}" }

        # fzf 실행 후 선택된 파일 경로 저장
        $file = fzf --preview $previewCmd

        # 사용자가 취소(ESC)하지 않고 파일을 정상 선택한 경우에만 에러 없이 에디터 실행
        if ($file) {
            # 환경변수 $env:EDITOR가 있으면 해당 에디터로, 없으면 기본 vim으로 실행
            $editor = if ($env:EDITOR) { $env:EDITOR } else { "vim" }
            Start-Process $editor -ArgumentList (Protect-String $file) -NoNewWindow -Wait
        }
    }

    # fat: fzf로 파일을 찾아 Vim(또는 기본 에디터)으로 열기
    function fat {
        # Windows 환경(winget/scoop 설치 등)에 맞춰 'bat' 명령어가 있는지 확인, 없으면 기본 'type'으로 대체
        $batCmd = if (Get-Command bat -ErrorAction SilentlyContinue) { "bat" } else { "type" }

        # fzf 미리보기 명령 구성 (줄 번호, 색상 활성화, 상위 500줄 제한)
        $previewCmd = if ($batCmd -eq "bat") {
            "bat --style=numbers --color=always --line-range :500 {}"
        } else {
            "type {}"
        }

        # fzf를 실행하여 사용자가 선택한 파일 경로 저장
        $file = fzf --preview $previewCmd

        # 사용자가 취소(ESC)하지 않고 파일 경로를 정상적으로 반환했을 때만 출력 실행
        if ($file) {
            if ($batCmd -eq "bat") {
                # 테두리와 줄 번호는 제외하고, 파일 이름(header)만 상단에 표시하며 본문 출력
                bat --style=header $file
            } else {
                # 시스템에 bat가 없는 경우 순정 파일 내용 출력
                Get-Content $file
            }
        }
    }

    # frm: fzf로 여러 파일을 다중 선택(-m)하여 안전하게 대화형 삭제(-Confirm)
    function frm {
        # fd로 파일 목록을 뽑아 fzf 다중 선택(-m) 창으로 넘김
        $files = fd --type f | fzf -m

        # 사용자가 하나 이상의 파일을 선택했을 때만 실행
        if ($files) {
            # 각 파일마다 정말 지울지 윈도우/PS 순정 확인 창(-Confirm)을 띄우며 안전하게 삭제
            $files | Remove-Item -Force -Confirm
        }
    }
}

########################################
# Import User Script Profile
########################################
# Store multiple file paths in an array variable
# Create a dedicated directory for your custom scripts
$ScriptFolder = "$HOME\Documents\PowerShell\Scripts\UserScripts"

if (Test-Path $ScriptFolder) {
    # Get all .ps1 files and dot-source them automatically
    Get-ChildItem -Path $ScriptFolder -Filter *.ps1 | ForEach-Object {
        . $_.FullName
    }
}

########################################
# oh-my-posh
########################################
#oh-my-posh init pwsh | Invoke-Expression
oh-my-posh init pwsh --config "$env:USERPROFILE\.env\posh\themes\pure.omp.json" | Invoke-Expression
