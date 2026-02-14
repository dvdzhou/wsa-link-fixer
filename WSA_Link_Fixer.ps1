<#
.SYNOPSIS
    WSA Link Fixer - Fixes browser link issues caused by Windows Android Subsystem (WSA).
    
.AUTHOR
    dvdzhou (GitHub)
    
.LICENSE
    MIT License - Copyright (c) 2026 dvdzhou
#>

# Configuration
$wsaKey = "HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppModel\SystemAppData\MicrosoftCorporationII.WindowsSubsystemForAndroid_8wekyb3d8bbwe\AppUriHandlers"

Clear-Host
Write-Host "--- WSA LINK FIXER (Browser Conflict Resolver) ---" -ForegroundColor Cyan
Write-Host "This tool fixes the issue where links from Windows apps fail to open due to Android Subsystem."

# INITIAL CHECK
if (-not (Test-Path $wsaKey)) {
    Write-Host "`n[V] Good news! No conflicting Android settings found." -ForegroundColor Green
    Write-Host "Your links should be opening correctly in your default browser."
    Write-Host "`nPress any key to exit..."
    $null = [System.Console]::ReadKey(); exit
}

Write-Host "`n[!] ALERT: Android (WSA) settings are currently hijacking your web links." -ForegroundColor Yellow

# --- STEP 1: WSA MANAGEMENT ---
Write-Host "`nPhase 1: Preparation" -ForegroundColor White
Write-Host "To fix the registry safely, the Android Subsystem must be turned off."
$wsaChoice = Read-Host "Attempt to shutdown Android subsystem automatically? (Y/N)"

if ($wsaChoice -eq "y" -or $wsaChoice -eq "Y") {
    Write-Host "Sending shutdown command..." -ForegroundColor Gray
    & "WSAClient.exe" /shutdown
    
    # Verify shutdown
    $timer = 0
    Write-Host "Verifying shutdown..." -NoNewline
    while ((Get-Process -Name "WsaClient" -ErrorAction SilentlyContinue) -and ($timer -lt 15)) {
        Write-Host "." -NoNewline
        Start-Sleep -Seconds 1
        $timer++
    }
    
    if (Get-Process -Name "WsaClient" -ErrorAction SilentlyContinue) {
        Write-Host "`n[!] Android is not responding. The fix might fail if files are locked." -ForegroundColor Red
    } else {
        Write-Host "`n[OK] Android subsystem shutdown successfully." -ForegroundColor Green
    }
} else {
    Write-Host "Skipping auto-shutdown. Ensure WSA is closed manually before proceeding." -ForegroundColor Gray
}

# --- STEP 2: APPLYING THE FIX ---
$timestamp = Get-Date -Format "yyyyMMdd_HHmm"
$newName = "AppUriHandlers_old_$timestamp"

Write-Host "`nPhase 2: Applying the Fix" -ForegroundColor White
Write-Host "I will rename the conflicting registry key to backup your current settings."
$fixChoice = Read-Host "Proceed with the fix now? (Y/N)"

if ($fixChoice -eq "y" -or $fixChoice -eq "Y") {
    try {
        Rename-Item -Path $wsaKey -NewName $newName -ErrorAction Stop
        Write-Host "[OK] Conflict removed. Backup created as: $newName" -ForegroundColor Green
    } catch {
        Write-Host "[ERROR] Could not rename the key. Android might still be running." -ForegroundColor Red
        Write-Host "Please restart your PC and run this script again BEFORE opening any Android apps."
        Write-Host "`nPress any key to exit..."; $null = [System.Console]::ReadKey(); exit
    }
} else {
    Write-Host "Operation cancelled. No changes made." -ForegroundColor White
    Write-Host "`nPress any key to exit..."; $null = [System.Console]::ReadKey(); exit
}

# --- STEP 3: SYSTEM REFRESH ---
Write-Host "`nPhase 3: Activate Changes" -ForegroundColor White
Write-Host "Windows Explorer needs to restart to apply the changes immediately."
Write-Host "NOTE: This will close any open file folders (your browser and apps will stay open)." -ForegroundColor Yellow
$explChoice = Read-Host "Restart Windows Explorer now? (Y/N)"

if ($explChoice -eq "y" -or $explChoice -eq "Y") {
    Write-Host "Restarting Explorer..." -ForegroundColor Gray
    Stop-Process -Name explorer -Force
    Write-Host "`n[DONE] Issue resolved! Try clicking a link now." -ForegroundColor Green
} else {
    Write-Host "`n[NOTE] You chose not to restart Explorer. You must restart your PC to see the fix." -ForegroundColor Yellow
}

Write-Host "`nPress any key to close this tool..."
$null = [System.Console]::ReadKey()