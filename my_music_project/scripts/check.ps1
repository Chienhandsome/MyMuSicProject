# Script kiem tra truoc khi push (danh cho Windows PowerShell)
# Su dung: .\scripts\check.ps1

Write-Host "=== Kiem tra dinh dang ===" -ForegroundColor Cyan
dart format --set-exit-if-changed .
if ($LASTEXITCODE -ne 0) {
    Write-Host "THAT BAI: Code chua duoc format dung." -ForegroundColor Red
    Write-Host "Chay 'dart format .' de fix." -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "=== Phan tich code ===" -ForegroundColor Cyan
flutter analyze --fatal-infos
if ($LASTEXITCODE -ne 0) {
    Write-Host "THAT BAI: Co loi analyze." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "=== Chay tests ===" -ForegroundColor Cyan
flutter test
if ($LASTEXITCODE -ne 0) {
    Write-Host "THAT BAI: Co test khong pass." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "=== TAT CA DIEU PASS ===" -ForegroundColor Green
