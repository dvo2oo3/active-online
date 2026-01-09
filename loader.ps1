# loader.ps1
$scriptUrl = "https://raw.githubusercontent.com/dvo2oo3/active-online/main/MAS_AIO.cmd"
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  MAS Activation Script Loader" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check admin
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "[!] Can quyen Administrator!" -ForegroundColor Red
    Write-Host "[*] Dang khoi dong lai voi quyen Admin..." -ForegroundColor Yellow
    $scriptContent = $MyInvocation.MyCommand.ScriptContents
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -Command `"& {$scriptContent}`"" -Verb RunAs
    exit
}

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
}

# Pause cuoi cung
Write-Host ""
Write-Host "Nhan phim bat ky de dong cua so..." -ForegroundColor Yellow
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
