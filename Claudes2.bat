@echo off
setlocal
:: ============================================================
::  Claude2 launcher - runs a second Claude Desktop instance
::  as another Windows user (UserClaude).
::  - Syncs the copy in C:\Tools\Claude2 when Claude updates
::  - Asks for the password only on first run (/savecred)
:: ============================================================
::  SETUP NOTES:
::  1. If your second Windows user has a different name,
::     change WINUSER below.
::  2. Run this file once with "Run as administrator" so the
::     C:\Tools\Claude2 folder can be created. After that,
::     a normal double-click is enough.
::  3. Close Claude2 before updating, otherwise the copy fails.
:: ============================================================

set "WINUSER=UserClaude"
set "DEST=C:\Tools\Claude2"

:: Sync the copy with the installed Claude version (only if changed)
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$p = Get-AppxPackage Claude;" ^
  "if (-not $p) { Write-Host 'Claude (MSIX) not found.'; exit 1 };" ^
  "$v = $p.Version.ToString(); $f = '%DEST%\.version';" ^
  "$cur = if (Test-Path $f) { Get-Content $f } else { '' };" ^
  "if ($v -ne $cur) {" ^
  "  Write-Host \"Updating Claude2 to $v ...\";" ^
  "  robocopy (Join-Path $p.InstallLocation 'app') '%DEST%' /MIR /XF .version /NFL /NDL /NJH /NJS | Out-Null;" ^
  "  if ($LASTEXITCODE -ge 8) { Write-Host 'Copy failed. Close Claude2 or run this file as Administrator once.'; exit 1 };" ^
  "  Set-Content $f $v }"

if errorlevel 1 (
  pause
  exit /b 1
)

:: Launch as the second user (password asked only the first time)
runas /user:%WINUSER% /savecred "%DEST%\claude.exe"
