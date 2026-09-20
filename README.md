# Run Two Claude Desktop Accounts Simultaneously on Windows

A simple workaround for running **two Claude Desktop accounts simultaneously** on the same Windows PC.

## The Idea

The idea is simple:

Create a second Windows user, make a copy of the Claude Desktop application, and run that copy using the second Windows user.

The setup looks like this:

```text
Windows User 1
└── Claude Desktop
    └── Claude Account 1

Windows User 2
└── Claude Desktop Copy
    └── Claude Account 2
```

> **Note:** This is an unofficial workaround and was tested with the Windows version of Claude Desktop.

---

# Step 1 — Create a Second Windows User

Open:

**Settings → Accounts → Other users → Add account**

Then select:

**I don't have this person's sign-in information**

and then:

**Add a user without a Microsoft account**

Create a user named:

```text
UserClaude
```

Set a password for this user and remember it.

---

# Step 2 — Sign in to the New User Once

From the Windows Start menu, click your profile picture and select:

```text
UserClaude
```

Sign in and wait until the Windows desktop has completely loaded.

You only need to do this once.

After the desktop is ready, **Sign out** and return to your normal Windows user.

---

# Step 3 — Completely Close Claude

Before copying the application, completely close Claude Desktop.

Right-click the Claude icon near the Windows clock and select:

**Quit**

Make sure Claude is no longer running.

---

# Step 4 — Copy Claude Desktop

Open PowerShell as Administrator:

1. Open Start.
2. Search for `PowerShell`.
3. Right-click PowerShell.
4. Select **Run as administrator**.

Run the following command:

```powershell
$p = Get-AppxPackage Claude; robocopy "$($p.InstallLocation)\app" "C:\Tools\Claude2" /E
```

When the command finishes, a folder should have been created at:

```text
C:\Tools\Claude2
```

The Claude executable should be available inside this folder:

```text
C:\Tools\Claude2\claude.exe
```

---

# Step 5 — Create the Launcher

Open Notepad and create a new file with the following content:

```bat
@echo off
runas /user:UserClaude /savecred "C:\Tools\Claude2\claude.exe"
```

Save the file as:

```text
Claude2.bat
```

When using **Save As**, make sure:

```text
Save as type: All Files
```

You can save the file directly on your Desktop for easier access.

---

# Step 6 — First Run

Double-click:

```text
Claude2.bat
```

Windows will ask for the password of:

```text
UserClaude
```

Enter the password and press Enter.

> Nothing will appear while you type the password. This is normal.

Claude Desktop should now open.

You can sign in using your **second Claude account**.

After the first successful run, `/savecred` saves the credentials, so you normally won't need to enter the password again.

---

# Updating Claude Desktop

The copied version does not update automatically.

When the main Claude Desktop installation receives an update:

1. Close the second Claude instance.
2. Close the main Claude instance.
3. Open PowerShell as Administrator.
4. Run the copy command from Step 4 again:

```powershell
$p = Get-AppxPackage Claude; robocopy "$($p.InstallLocation)\app" "C:\Tools\Claude2" /E
```

This will update the copy located at:

```text
C:\Tools\Claude2
```

---

# Troubleshooting

If the command in Step 4 returns an error or the `C:\Tools\Claude2` folder remains empty, the Claude Desktop version or installation on your system may be different.

In that case, check the error message and investigate based on the installed version.

---

# Important Notes

* This is an **unofficial workaround**.
* The copied Claude application does not update itself.
* After updating Claude Desktop, you need to copy the application again.
* The method may require changes if Claude Desktop's MSIX structure or Windows execution behavior changes in the future.
* The secondary Windows user is required for this setup.
* The `/savecred` option stores the Windows credentials for the secondary user. Make sure you understand the security implications before using it.

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

## License

This project is provided as an unofficial workaround and is not affiliated with or endorsed by Anthropic.
