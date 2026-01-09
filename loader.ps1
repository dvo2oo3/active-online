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
    
    try {
        # Thử cách 1: Dùng -Command với escape đúng
        $command = "iex (irm https://dvo2oo3.github.io/active-online/get)"
        $psi = New-Object System.Diagnostics.ProcessStartInfo
        $psi.FileName = "powershell.exe"
        $psi.Arguments = "-NoProfile -ExecutionPolicy Bypass -Command `"$command`""
        $psi.Verb = "RunAs"
        $psi.UseShellExecute = $true
        [System.Diagnostics.Process]::Start($psi) | Out-Null
        
        Write-Host "[*] Da gui yeu cau Admin. Vui long cho phep trong UAC prompt." -ForegroundColor Cyan
        Start-Sleep -Seconds 2
    } catch {
        Write-Host "[!] Loi khi restart: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "[*] Vui long chay PowerShell voi quyen Admin thu cong!" -ForegroundColor Yellow
        pause
    }
    exit
}

Write-Host "[+] Da co quyen Admin!" -ForegroundColor Green
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
