# Run Two Claude Desktop Accounts on Windows

A simple workaround for running **two separate Claude Desktop accounts simultaneously** on the same Windows PC.

The idea is simple:

```text
Windows User 1
    └── Claude Desktop
        └── Claude Account 1

Windows User 2
    └── Claude Desktop copy
        └── Claude Account 2
```

Instead of trying to run two accounts under the same Windows user, we create a second Windows user, make a copy of Claude Desktop, and run that copy using the second Windows user.

> **Status:** Tested workaround
> **Platform:** Windows 10 / Windows 11
> **App:** Claude Desktop

---

## How It Works

Claude Desktop normally keeps its account/session information within the Windows user environment.

This workaround uses:

1. A second Windows user.
2. A copy of the Claude Desktop application.
3. `runas` to launch the copied application under the second Windows user.

The second copy is stored in:

```text
C:\Tools\Claude2
```

and is launched using:

```text
runas
```

This allows the two Claude instances to run under separate Windows user environments.

---

# Installation

## 1. Create a Second Windows User

Open:

```text
Settings
→ Accounts
→ Other users
→ Add account
```

Then select:

```text
I don't have this person's sign-in information
```

and then:

```text
Add a user without a Microsoft account
```

Create a user such as:

```text
UserClaude
```

Set a password for this account.

**Remember the password.**

---

## 2. Sign in to the New Windows User Once

Sign out from your current Windows account and sign in using:

```text
UserClaude
```

Wait until the Windows desktop has completely loaded.

You only need to do this once so Windows creates the user's profile.

After that, sign out and return to your normal Windows account.

---

## 3. Close Claude Desktop

Before copying the application, completely close Claude Desktop.

Right-click the Claude icon near the Windows clock and select:

```text
Quit
```

Make sure Claude Desktop is no longer running.

---

## 4. Copy Claude Desktop

Open **PowerShell as Administrator**.

Run:

```powershell
$p = Get-AppxPackage Claude; robocopy "$($p.InstallLocation)\app" "C:\Tools\Claude2" /E
```

This copies the Claude Desktop application files to:

```text
C:\Tools\Claude2
```

After the command finishes, you should have:

```text
C:\Tools\Claude2\claude.exe
```

---

## 5. Create the Launcher

Create a file named:

```text
Claude2.bat
```

You can put it on your Desktop for easy access.

Use the following content:

```bat
@echo off

REM ------------------------------------------------------------
REM Run the second Claude Desktop instance using the
REM secondary Windows user.
REM
REM Change "UserClaude" if you used a different Windows
REM username.
REM ------------------------------------------------------------

runas /user:UserClaude /savecred "C:\Tools\Claude2\claude.exe"
```

If you used a different Windows username, change:

```bat
UserClaude
```

to your username.

---

## 6. Run Claude for the Second Account

Double-click:

```text
Claude2.bat
```

The first time, Windows will ask for the password of:

```text
UserClaude
```

Enter the password and press Enter.

> Nothing will appear while typing the password. This is normal.

Claude Desktop should now start under the second Windows user.

You can now sign in using your **second Claude account**.

---

## Running Both Accounts

After setup, you should be able to use:

```text
Claude Desktop
    → Account 1

Claude Desktop - Second Instance
    → Account 2
```

Both instances can be open at the same time.

---

# Updating Claude Desktop

The copied application does **not automatically update** when the main Claude Desktop installation is updated.

If Claude Desktop receives an update:

1. Close the second Claude instance.
2. Close the main Claude instance.
3. Open **PowerShell as Administrator**.
4. Run the copy command again:

```powershell
$p = Get-AppxPackage Claude; robocopy "$($p.InstallLocation)\app" "C:\Tools\Claude2" /E
```

This updates the files in:

```text
C:\Tools\Claude2
```

After that, run `Claude2.bat` again.

---

# Creating a Desktop Shortcut

For easier access, you can create a shortcut to:

```text
Claude2.bat
```

Then you can simply double-click the shortcut whenever you want to open the second Claude account.

You can also change the shortcut icon to the Claude executable:

```text
C:\Tools\Claude2\claude.exe
```

---

# Security Note

The launcher uses:

```text
runas /savecred
```

`/savecred` tells Windows to remember the credentials after the first successful login.

This means you normally won't need to enter the `UserClaude` password every time you run `Claude2.bat`.

Be aware that saved Windows credentials have security implications.

Use this only on a computer where you understand and accept the risks.

---

# Troubleshooting

## `claude.exe` was not found

Check that the following file exists:

```text
C:\Tools\Claude2\claude.exe
```

If it does not exist, run the PowerShell copy command again as Administrator:

```powershell
$p = Get-AppxPackage Claude; robocopy "$($p.InstallLocation)\app" "C:\Tools\Claude2" /E
```

---

## The copy command doesn't work

Run:

```powershell
Get-AppxPackage Claude
```

If Claude Desktop is installed correctly, PowerShell should return information about the Claude package.

If nothing is returned, the package name or installation method may be different on your system.

---

## Claude doesn't start with the second account

Make sure:

* `UserClaude` exists.
* You have signed in to `UserClaude` at least once.
* Claude Desktop is completely closed before copying the files.
* `C:\Tools\Claude2\claude.exe` exists.
* The password used with `runas` is correct.

---

# Limitations

This is an **unofficial workaround**, not an official Claude Desktop feature.

It may stop working or require changes if:

* Claude Desktop changes its Windows packaging.
* Anthropic changes the MSIX application structure.
* The authentication process changes.
* Windows changes its application security or execution behavior.

The method was tested with the Windows MSIX version of Claude Desktop.

---

# Disclaimer

This project is not affiliated with or endorsed by Anthropic.

Claude and Claude Desktop are trademarks and products of Anthropic.

This repository documents a personal workaround for running separate Claude Desktop accounts on Windows.

Use it at your own risk.

---

# Repository Structure

```text
claude-desktop-dual-windows/
│
├── README.md
├── Claude2.bat
└── LICENSE
```

---

# Contributing

If you find a more reliable way to run multiple Claude Desktop accounts on Windows, feel free to open an issue or submit a pull request.

Useful contributions include:

* Compatibility fixes for newer Claude Desktop versions
* Better Windows 10/11 support
* Alternative approaches
* Documentation improvements
* Troubleshooting information

---

# License

This project is released under the MIT License.

See [`LICENSE`](LICENSE) for details.
