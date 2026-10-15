# ==============================================================================
# KAZE - Universal 1-Line Installer for Windows
# Run: irm https://github.com/yashh1323/kaze/releases/latest/download/install.ps1 | iex
# ==============================================================================

[CmdletBinding()]
param(
    [string]$Repo = "yashh1323/kaze",
    [string]$Version = "latest"
)

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "            KAZE Installer for Windows" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host ""

# 1. Define destination paths
$installDir = Join-Path $env:USERPROFILE ".kaze\bin"
$targetExe = Join-Path $installDir "kaze.exe"

if (-not (Test-Path $installDir)) {
    New-Item -ItemType Directory -Path $installDir -Force | Out-Null
}

# 2. Determine download URL
$downloadUrl = "https://github.com/$Repo/releases/latest/download/kaze-windows-amd64.zip"
if ($Version -ne "latest") {
    $downloadUrl = "https://github.com/$Repo/releases/download/$Version/kaze-windows-amd64.zip"
}

# Check for local fallback if installer is run directly inside repo
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$localExe = $null
if ($scriptDir) {
    $potentialExe = Join-Path $scriptDir "kaze.exe"
    if (Test-Path $potentialExe) {
        $localExe = $potentialExe
    }
}

function Install-SafeExecutable($src, $dst) {
    $parentDir = Split-Path -Parent $dst
    if (-not (Test-Path $parentDir)) {
        New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
    }
    if (Test-Path $dst) {
        try {
            Copy-Item -Path $src -Destination $dst -Force -ErrorAction Stop
        } catch {
            $backup = "$dst.old"
            Remove-Item -Path $backup -Force -ErrorAction SilentlyContinue
            Rename-Item -Path $dst -NewName "$([System.IO.Path]::GetFileName($dst)).old" -Force -ErrorAction SilentlyContinue
            Copy-Item -Path $src -Destination $dst -Force
            Remove-Item -Path $backup -Force -ErrorAction SilentlyContinue
        }
    } else {
        Copy-Item -Path $src -Destination $dst -Force
    }
}

if ($localExe) {
    Write-Host "[+] Installing from local build: $localExe..." -ForegroundColor Yellow
    Install-SafeExecutable $localExe $targetExe
    $scoopShim = Join-Path $env:USERPROFILE "scoop\shims\kaze.exe"
    if (Test-Path $scoopShim) {
        Install-SafeExecutable $localExe $scoopShim
    }
} else {
    Write-Host "[+] Downloading Kaze from GitHub Releases..." -ForegroundColor Yellow
    Write-Host "    $downloadUrl" -ForegroundColor DarkGray
    
    $tempZip = Join-Path ([System.IO.Path]::GetTempPath()) "kaze-install-$([System.Guid]::NewGuid()).zip"
    $tempExtract = Join-Path ([System.IO.Path]::GetTempPath()) "kaze-extract-$([System.Guid]::NewGuid())"
    
    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Invoke-WebRequest -Uri $downloadUrl -OutFile $tempZip -UseBasicParsing
        
        Expand-Archive -Path $tempZip -DestinationPath $tempExtract -Force
        $extractedExe = Get-ChildItem -Path $tempExtract -Filter "kaze.exe" -Recurse | Select-Object -First 1
        
        if (-not $extractedExe) {
            throw "kaze.exe not found inside the downloaded archive."
        }
        
        Install-SafeExecutable $extractedExe.FullName $targetExe
        $scoopShim = Join-Path $env:USERPROFILE "scoop\shims\kaze.exe"
        if (Test-Path $scoopShim) {
            Install-SafeExecutable $extractedExe.FullName $scoopShim
        }
    } catch {
        Write-Error "Download failed: $_`nPlease check if the release exists on https://github.com/$Repo/releases."
        exit 1
    } finally {
        if (Test-Path $tempZip) { Remove-Item -Force $tempZip -ErrorAction SilentlyContinue }
        if (Test-Path $tempExtract) { Remove-Item -Force -Recurse $tempExtract -ErrorAction SilentlyContinue }
    }
}

# 3. Add to persistent User PATH
$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
$pathParts = @()
if ($userPath) {
    $pathParts = $userPath -split ';'
}

if ($pathParts -notcontains $installDir) {
    Write-Host "[+] Adding $installDir to persistent User PATH..." -ForegroundColor Yellow
    $newPath = $installDir
    if ($userPath) {
        $newPath = "$userPath;$installDir"
    }
    [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
    $env:Path = "$installDir;" + $env:Path
    Write-Host "  -> PATH updated." -ForegroundColor Green
} else {
    Write-Host "[+] $installDir is already in User PATH." -ForegroundColor Green
}

# 4. Check for MPV player dependency
$mpvCmd = Get-Command "mpv" -ErrorAction SilentlyContinue
if ($mpvCmd) {
    Write-Host "[+] mpv video player detected in PATH ($($mpvCmd.Source))." -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "[!] Note: 'mpv' player was not found in your PATH." -ForegroundColor Magenta
    Write-Host "    Kaze uses mpv for hardware accelerated playback." -ForegroundColor Gray
    Write-Host "    Install it easily using: winget install mpv.net (or scoop install mpv)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "==========================================================" -ForegroundColor Green
Write-Host "  KAZE INSTALLED SUCCESSFULLY!" -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Green
Write-Host " Installed at: $targetExe"
Write-Host ""
Write-Host " You can now run 'kaze' from any PowerShell or Command Prompt!" -ForegroundColor Cyan
Write-Host " Example:" -ForegroundColor Gray
Write-Host "   kaze                  (interactive menu)" -ForegroundColor White
Write-Host "   kaze '<title>'        (instant search)" -ForegroundColor White
Write-Host ""
