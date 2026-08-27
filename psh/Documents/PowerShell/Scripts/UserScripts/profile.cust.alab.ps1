function clean-java-cache {
    $gradlePath = "~\.gradle\caches\modules-2\files-2.1"
    $mavenPath  = "~\.m2\repository"

    # Gradle 캐시 처리
    if (Test-Path $gradlePath) {
        Remove-Item -Path $gradlePath -Recurse -Force *> $null
        Write-Host "✔ Gradle 캐시 디렉토리를 삭제했습니다." -ForegroundColor Cyan
    }

    # Maven 저장소 처리
    if (Test-Path $mavenPath) {
        Remove-Item -Path $mavenPath -Recurse -Force *> $null
        Write-Host "✔ Maven 로컬 라이브러리를 삭제했습니다." -ForegroundColor Cyan
    }
}