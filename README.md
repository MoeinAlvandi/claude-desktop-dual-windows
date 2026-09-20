# Run Two Claude Desktop Accounts on Windows

A practical Windows workaround for running **two separate Claude Desktop accounts simultaneously** on the same PC.

Claude Desktop is designed around a single Windows user environment, which makes running two accounts at the same time difficult. This project uses a **separate Windows user account** and a **local synchronized copy of the Claude Desktop application** to run a second instance.

> **Status:** Tested workaround
> **Platform:** Windows 10 / Windows 11
> **App:** Claude Desktop

---

## Why?

If you need to work with two different Claude accounts, the normal approaches have some limitations.

For example:

* Running Claude Desktop normally only gives you one account.
* `runas` cannot directly launch the MSIX-installed Claude Desktop application.
* The Claude executable inside `WindowsApps` cannot normally be launched directly by another Windows user.
* Registering the MSIX package for another Windows user does not necessarily allow the application to be activated through `runas`.

This repository provides a workaround based on a second Windows user and a separate application copy.

---

## How It Works

The setup uses:

```text
Windows User 1
    │
    └── Claude Desktop
        └── Account 1


Windows User 2
    │
    └── Claude Desktop copy
        └── Account 2
```

The second Claude Desktop application is copied from the installed MSIX package into:

```text
C:\Tools\Claude2
```

The application is then launched under a separate Windows user using:

```text
runas
```

Each Windows user maintains its own application/session environment, allowing two Claude accounts to be used at the same time.

---

## Features

* Run two Claude Desktop accounts simultaneously
* Use separate Windows user accounts
* No need to modify Claude Desktop source files
* Automatically synchronize the copied Claude application when a new version is detected
* Launch the second instance with a desktop shortcut
* Works with the MSIX version of Claude Desktop

---

## Requirements

* Windows 10 or Windows 11
* Claude Desktop installed normally
* Administrator access to create the second Windows user
* A separate Claude account for the second instance

---

## Installation

### 1. Create a second Windows user

Open **Command Prompt as Administrator** and run:

```bat
net user ClaudeAlt * /add
```

Windows will ask you to choose a password.

You can use another username if you prefer. If you do, change `ALT_USER` in the batch file accordingly.

---

### 2. Sign in to the new Windows account once

Sign in to Windows using:

```text
ClaudeAlt
```

You only need to do this once so Windows creates the user's profile.

After the profile is created, sign out and return to your normal Windows account.

---

### 3. Create the Claude launcher

Create a file named:

```text
Claude2.bat
```

and put the following content inside it:

```bat
@echo off

set "ALT_USER=ClaudeAlt"
set "DEST=C:\Tools\Claude2"

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$p = Get-AppxPackage Claude; if (-not $p) { Write-Host 'Claude not installed'; exit 1 };" ^
  "$v = $p.Version.ToString(); $f = '%DEST%\.version';" ^
  "if (-not (Test-Path $f) -or (Get-Content $f) -ne $v) {" ^
  "  Write-Host \"Syncing Claude $v ...\";" ^
  "  robocopy (Join-Path $p.InstallLocation 'app') '%DEST%' /MIR /XF .version /NFL /NDL /NJH /NJS | Out-Null;" ^
  "  Set-Content $f $v }"

runas /user:%ALT_USER% /savecred "%DEST%\claude.exe"
```

---

### 4. Run the launcher

Double-click:

```text
Claude2.bat
```

The first time Windows will ask for the password of:

```text
ClaudeAlt
```

After authentication, Claude Desktop will start under the second Windows user.

Sign in to your **second Claude account**.

---

## Creating a Desktop Shortcut

For easier access:

1. Right-click `Claude2.bat`
2. Select **Send to → Desktop (create shortcut)**
3. Right-click the shortcut
4. Open **Properties**
5. Set:

```text
Run: Minimized
```

You can also change the shortcut icon to the Claude executable:

```text
C:\Tools\Claude2\claude.exe
```

This gives you a dedicated shortcut for launching the second Claude account.

---

## Updating Claude Desktop

The copied application does not update itself automatically.

The batch file checks the installed Claude Desktop version every time it starts.

If a new version is detected, it synchronizes the application files:

```text
Installed Claude
       ↓
C:\Tools\Claude2
```

The synchronization is performed using:

```bat
robocopy /MIR
```

Therefore, `C:\Tools\Claude2` should be treated as a dedicated directory for this Claude copy.

### Important

Before updating the copied files, make sure the second Claude instance is closed.

If Claude is still running from `C:\Tools\Claude2`, the synchronization may fail for files that are currently in use.

---

## Login Issues

Depending on the version of Claude Desktop and Windows, the authentication process may open the login link in your default browser.

If the second Claude instance does not complete the login correctly:

1. Close the first Claude Desktop instance temporarily.
2. Start `Claude2.bat`.
3. Complete the login for the second account.
4. After the second account is authenticated, start your first Claude instance again.

The exact authentication behavior may change with future Claude Desktop releases.

---

## Why Not Just Use `runas`?

Claude Desktop is distributed as an MSIX application.

This means that simply doing something like:

```bat
runas /user:ClaudeAlt "Claude.exe"
```

does not work reliably with the normal MSIX installation.

The executable is installed under a protected WindowsApps directory and application activation is handled through Windows' packaged-app infrastructure.

The workaround avoids this limitation by copying the application files to a normal directory:

```text
C:\Tools\Claude2
```

and then launching that copy under the second Windows user.

---

## Limitations

This is a practical workaround, not an official Claude Desktop feature.

Potential limitations include:

* Claude Desktop updates may change the application structure.
* The copied application does not update itself.
* The batch file needs to synchronize the application after updates.
* Authentication behavior may change in future versions.
* The workaround may stop working if Anthropic changes how Claude Desktop is packaged or launched.
* Windows security policies may behave differently on different systems.

---

## Security Considerations

The launcher uses:

```text
runas /savecred
```

This allows Windows to remember the credentials for the secondary account so you don't have to enter the password every time.

Understand the security implications before using `/savecred`.

For better isolation, use a dedicated Windows user with only the permissions you actually need.

Do **not** put passwords, Claude session data, authentication tokens, cookies, or other credentials in this repository.

---

## Removing the Setup

If you want to completely remove the second Claude environment:

### Delete the Windows user

Run Command Prompt as Administrator:

```bat
net user ClaudeAlt /delete
```

### Delete the copied application

```powershell
Remove-Item C:\Tools\Claude2 -Recurse -Force
```

### Remove saved credentials

If you used `/savecred`, remove the stored credentials from **Windows Credential Manager**.

---

## Disclaimer

This project is an **unofficial community workaround**.

It is not affiliated with, maintained by, or endorsed by Anthropic.

Use it at your own risk.

The behavior of Claude Desktop, Windows MSIX packaging, authentication, or account management may change at any time.

---

## Project Structure

```text
claude-desktop-dual-windows/
│
├── README.md
├── Claude2.bat
├── LICENSE
└── screenshots/
    └── two-claude-instances.png
```

---

## Contributing

If you discover a better way to run multiple Claude Desktop accounts on Windows, feel free to open an issue or submit a pull request.

Useful contributions include:

* Compatibility fixes for newer Claude Desktop versions
* Improvements to the synchronization script
* Windows 10/11 compatibility fixes
* Better documentation
* Alternative approaches that do not require a second Windows user

---

## License

This project is released under the MIT License.

See [`LICENSE`](LICENSE) for details.
