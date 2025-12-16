# Script nay duoc luu tru tai https://web.facebook.com/dvo2oo3

# Gap kho khan khi chay script? Xem https://web.facebook.com/dvo2oo3 de duoc tro giup.

if (-not $args) {
    Write-Host ''
    Write-Host 'Can tro giup? Ghe trang chu cua chung toi: ' -NoNewline
    Write-Host 'https://web.facebook.com/dvo2oo3' -ForegroundColor Green
    Write-Host ''
}

& {
    $psv = (Get-Host).Version.Major
    $troubleshoot = 'https://web.facebook.com/dvo2oo3'

    if ($ExecutionContext.SessionState.LanguageMode.value__ -ne 0) {
        $ExecutionContext.SessionState.LanguageMode
        Write-Host "PowerShell khong chay o che do Full Language Mode."
        Write-Host "Tro giup - https://web.facebook.com/dvo2oo3" -ForegroundColor White -BackgroundColor Blue
        return
    }

    try {
        [void][System.AppDomain]::CurrentDomain.GetAssemblies(); [void][System.Math]::Sqrt(144)
    }
    catch {
        Write-Host "Loi: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "Powershell khong the tai lenh .NET."
        Write-Host "Tro giup - https://web.facebook.com/dvo2oo3" -ForegroundColor White -BackgroundColor Blue
        return
    }

    function Check3rdAV {
        $cmd = if ($psv -ge 3) { 'Get-CimInstance' } else { 'Get-WmiObject' }
        $avList = & $cmd -Namespace root\SecurityCenter2 -Class AntiVirusProduct | Where-Object { $_.displayName -notlike '*windows*' } | Select-Object -ExpandProperty displayName

        if ($avList) {
            Write-Host 'Phan mem diet virus ben thu 3 co the dang chan script - ' -ForegroundColor White -BackgroundColor Blue -NoNewline
            Write-Host " $($avList -join ', ')" -ForegroundColor DarkRed -BackgroundColor White
        }
    }

    function CheckFile {
        param ([string]$FilePath)
        if (-not (Test-Path $FilePath)) {
            Check3rdAV
            Write-Host "Khong the tao file MAS trong thu muc tam, dang huy bo!"
            Write-Host "Tro giup - $troubleshoot" -ForegroundColor White -BackgroundColor Blue
            throw
        }
    }

    try { [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 } catch {}

    $URLs = @(
        'https://raw.githubusercontent.com/massgravel/Microsoft-Activation-Scripts/da0b2800d9c783e63af33a6178267ac2201adb2a/MAS/All-In-One-Version-KL/MAS_AIO.cmd',
        'https://dev.azure.com/massgrave/Microsoft-Activation-Scripts/_apis/git/repositories/Microsoft-Activation-Scripts/items?path=/MAS/All-In-One-Version-KL/MAS_AIO.cmd&versionType=Commit&version=da0b2800d9c783e63af33a6178267ac2201adb2a',
        'https://git.activated.win/Microsoft-Activation-Scripts/plain/MAS/All-In-One-Version-KL/MAS_AIO.cmd?id=da0b2800d9c783e63af33a6178267ac2201adb2a'
    )
    Write-Progress -Activity "Dang tai xuong..." -Status "Vui long doi"
    $errors = @()
    foreach ($URL in $URLs | Sort-Object { Get-Random }) {
        try {
            if ($psv -ge 3) {
                $response = Invoke-RestMethod $URL
            }
            else {
                $w = New-Object Net.WebClient
                $response = $w.DownloadString($URL)
            }
            break
        }
        catch {
            $errors += $_
        }
    }
    Write-Progress -Activity "Dang tai xuong..." -Status "Hoan tat" -Completed

    if (-not $response) {
        Check3rdAV
        foreach ($err in $errors) {
            Write-Host "Loi: $($err.Exception.Message)" -ForegroundColor Red
        }
        Write-Host "Khong the tai MAS tu bat ky kho luu tru nao, dang huy bo!"
        Write-Host "Kiem tra xem antivirus hoac firewall co dang chan ket noi khong."
        Write-Host "Tro giup - $troubleshoot" -ForegroundColor White -BackgroundColor Blue
        return
    }

    # Xac minh tinh toan ven cua script
    $releaseHash = '22D51870447129A730A66887C6E48B83B4B8B230CDC10E24597BA1CB0F471864'
    $stream = New-Object IO.MemoryStream
    $writer = New-Object IO.StreamWriter $stream
    $writer.Write($response)
    $writer.Flush()
    $stream.Position = 0
    $hash = [BitConverter]::ToString([Security.Cryptography.SHA256]::Create().ComputeHash($stream)) -replace '-'
    if ($hash -ne $releaseHash) {
        Write-Warning "Hash ($hash) khong khop, dang huy bo!`nBao cao van de nay tai $troubleshoot"
        $response = $null
        return
    }

    # Kiem tra AutoRun registry co the gay van de voi CMD
    $paths = "HKCU:\SOFTWARE\Microsoft\Command Processor", "HKLM:\SOFTWARE\Microsoft\Command Processor"
    foreach ($path in $paths) { 
        if (Get-ItemProperty -Path $path -Name "Autorun" -ErrorAction SilentlyContinue) { 
            Write-Warning "Tim thay registry Autorun, CMD co the bi crash! `nSao chep va dan lenh duoi day de sua...`nRemove-ItemProperty -Path '$path' -Name 'Autorun'"
        } 
    }

    $rand = [Guid]::NewGuid().Guid
    $isAdmin = [bool]([Security.Principal.WindowsIdentity]::GetCurrent().Groups -match 'S-1-5-32-544')
    $FilePath = if ($isAdmin) { "$env:SystemRoot\Temp\MAS_$rand.cmd" } else { "$env:USERPROFILE\AppData\Local\Temp\MAS_$rand.cmd" }
    Set-Content -Path $FilePath -Value "@::: $rand `r`n$response"
    CheckFile $FilePath

    $env:ComSpec = "$env:SystemRoot\system32\cmd.exe"
    $chkcmd = & $env:ComSpec /c "echo CMD dang hoat dong"
    if ($chkcmd -notcontains "CMD dang hoat dong") {
        Write-Warning "cmd.exe khong hoat dong.`nBao cao van de nay tai $troubleshoot"
    }

    if ($psv -lt 3) {
        if (Test-Path "$env:SystemRoot\Sysnative") {
            Write-Warning "Lenh dang chay voi Powershell x86, hay chay voi Powershell x64..."
            return
        }
        $p = saps -FilePath $env:ComSpec -ArgumentList "/c """"$FilePath"" -el -qedit $args""" -Verb RunAs -PassThru
        $p.WaitForExit()
    }
    else {
        saps -FilePath $env:ComSpec -ArgumentList "/c """"$FilePath"" -el $args""" -Wait -Verb RunAs
    }	
    CheckFile $FilePath

    $FilePaths = @("$env:SystemRoot\Temp\MAS*.cmd", "$env:USERPROFILE\AppData\Local\Temp\MAS*.cmd")
    foreach ($FilePath in $FilePaths) { Get-Item $FilePath -ErrorAction SilentlyContinue | Remove-Item }
} @args
```

```
Dang tai xuong... Vui long doi
Loi: Khong the tai MAS tu bat ky kho luu tru nao!
Tro giup - https://web.facebook.com/dvo2oo3