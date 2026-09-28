# ==========================================================
# ROSEY AI - Automated Android APK Build Script
# ==========================================================

$ErrorActionPreference = 'Stop'
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$SourceDir = Join-Path $ScriptDir 'ALTREX-CODE-source'
$DesktopDir = Join-Path $SourceDir 'apps\desktop'
$AndroidDir = Join-Path $DesktopDir 'android'
$OutputDir = $ScriptDir

Write-Host '==========================================================' -ForegroundColor Cyan
Write-Host '   ROSEY AI - Building Android APK for Phone' -ForegroundColor Cyan
Write-Host '==========================================================' -ForegroundColor Cyan
Write-Host ''

# 1. Check pnpm
$PnpmCmd = Join-Path $env:APPDATA 'npm\pnpm.cmd'
if (-not (Test-Path $PnpmCmd)) {
    if (Get-Command pnpm -ErrorAction SilentlyContinue) {
        $PnpmCmd = 'pnpm'
    } else {
        Write-Host '[!] Installing pnpm globally...' -ForegroundColor Yellow
        npm.cmd install -g pnpm
    }
}
Write-Host '[OK] Package manager ready.' -ForegroundColor Green

# 2. Check Java JDK
$JavaInstalled = $false
if (Test-Path 'C:\Program Files\Microsoft\jdk-17.0.20.101-hotspot') {
    $env:JAVA_HOME = 'C:\Program Files\Microsoft\jdk-17.0.20.101-hotspot'
    $env:Path = ($env:JAVA_HOME + '\bin;') + $env:Path
} elseif ($env:JAVA_HOME) {
    $env:Path = ($env:JAVA_HOME + '\bin;') + $env:Path
}

$JavaBin = Join-Path $env:JAVA_HOME 'bin\java.exe'
if (Test-Path $JavaBin) {
    $JavaInstalled = $true
    Write-Host ('[OK] Java JDK detected: ' + $env:JAVA_HOME) -ForegroundColor Green
} else {
    try {
        $prev = $ErrorActionPreference
        $ErrorActionPreference = 'SilentlyContinue'
        & java -version
        if ($LASTEXITCODE -eq 0) {
            $JavaInstalled = $true
            Write-Host '[OK] Java runtime active.' -ForegroundColor Green
        }
        $ErrorActionPreference = $prev
    } catch {
        Write-Host '[!] Java JDK is not detected in PATH.' -ForegroundColor Yellow
    }
}

# 3. Build Web Bundle
Write-Host ''
Write-Host '[1/3] Building mobile web application...' -ForegroundColor Cyan
Push-Location $DesktopDir
try {
    & $PnpmCmd run build:web
    Write-Host '[OK] Mobile web assets built successfully.' -ForegroundColor Green
} finally {
    Pop-Location
}

# 4. Sync Assets to Android
Write-Host ''
Write-Host '[2/3] Syncing assets to Android project...' -ForegroundColor Cyan
Push-Location $DesktopDir
try {
    & $PnpmCmd run sync:android
    Write-Host '[OK] Assets synced to Android.' -ForegroundColor Green
} finally {
    Pop-Location
}

# 5. Build APK
Write-Host ''
Write-Host '[3/3] Compiling Android APK...' -ForegroundColor Cyan
$BuiltApk = Join-Path $AndroidDir 'app\build\outputs\apk\debug\app-debug.apk'
$TargetApk = Join-Path $OutputDir 'ROSEY-AI.apk'

if ($JavaInstalled) {
    Push-Location $AndroidDir
    try {
        if (Test-Path '.\gradlew.bat') {
            .\gradlew.bat assembleDebug
        } elseif (Get-Command gradle -ErrorAction SilentlyContinue) {
            gradle assembleDebug
        } else {
            Write-Host '[!] Gradle wrapper not yet generated. Please open Android project in Android Studio to build.' -ForegroundColor Yellow
        }
    } catch {
        Write-Host ('[!] Gradle build encountered an error: ' + $_.Exception.Message) -ForegroundColor Yellow
    } finally {
        Pop-Location
    }

    if (Test-Path $BuiltApk) {
        Copy-Item $BuiltApk -Destination $TargetApk -Force
        Write-Host ''
        Write-Host '==========================================================' -ForegroundColor Green
        Write-Host 'SUCCESS: FULL PHONE APK IS READY!' -ForegroundColor Green
        Write-Host ('APK Location: ' + $TargetApk) -ForegroundColor Green
        Write-Host '==========================================================' -ForegroundColor Green
        Write-Host 'To install on your phone:'
        Write-Host '1. Connect your phone via USB or send ROSEY-AI.apk via Drive/WhatsApp/Telegram.'
        Write-Host '2. Tap to install the APK on your Android phone.'
        Write-Host '3. Open ROSEY AI and start coding!'
        exit 0
    }
}

Write-Host ''
Write-Host '----------------------------------------------------------' -ForegroundColor Yellow
Write-Host 'Android project and mobile web assets are ready!' -ForegroundColor Yellow
Write-Host ('Project location: ' + $AndroidDir) -ForegroundColor Yellow
Write-Host ''
Write-Host 'To generate your final .apk:' -ForegroundColor Cyan
Write-Host ('Option A (Android Studio): Open ' + $AndroidDir + ' in Android Studio -> Build -> Build APK(s).')
Write-Host 'Option B (GitHub Actions): Push repository to GitHub; the build-apk.yml workflow creates the APK automatically.'
Write-Host '----------------------------------------------------------' -ForegroundColor Yellow
