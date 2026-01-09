# loader.ps1 (VERSION ĐƠN GIẢN - dùng kèm .bat)
$scriptUrl = "https://raw.githubusercontent.com/dvo2oo3/active-online/main/MAS_AIO.cmd"
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  MAS Activation Script Loader" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "[*] Dang tai script tu GitHub..." -ForegroundColor Yellow

try {
    $tempFile = "$env:TEMP\MAS_$(Get-Random).cmd"
    Invoke-WebRequest -Uri $scriptUrl -OutFile $tempFile -UseBasicParsing
    
    if (Test-Path $tempFile) {
        Write-Host "[+] Tai thanh cong!" -ForegroundColor Green
        Write-Host "[*] Dang chay script..." -ForegroundColor Yellow
        Start-Process cmd.exe -ArgumentList "/c `"$tempFile`"" -Wait
        Remove-Item $tempFile -Force -ErrorAction SilentlyContinue
        Write-Host "[+] Hoan thanh!" -ForegroundColor Green
    } else {
        throw "Khong the tai file"
    }
} catch {
    Write-Host ""
    Write-Host "[!] LOI: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    Write-Host "Kiem tra:" -ForegroundColor Yellow
    Write-Host "1. Ket noi internet" -ForegroundColor Gray
    Write-Host "2. Link GitHub dung chua" -ForegroundColor Gray
    Write-Host "3. File ton tai trong repo" -ForegroundColor Gray
    Write-Host ""
    pause
}
