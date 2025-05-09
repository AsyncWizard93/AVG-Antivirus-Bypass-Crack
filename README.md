# AVG Antivirus Identifier Spoof Guide

Simple steps to locate and optionally spoof AVG-specific identifiers (e.g., installation ID or machine ID).

## 🔥 Download
🔗 [Download AVG Antivirus Full for free](https://repack-pc.info/dld/)

---

## **Identify AVG's Machine-Specific ID (If Available)**

Some AVG-related identifiers may reside in:

```
HKLM\SOFTWARE\AVG\
HKLM\SYSTEM\CurrentControlSet\Services\EventLog\Application\AVG
HKLM\SOFTWARE\WOW6432Node\AVG
```

Look for values like:

* `ProductGuid`
* `InstallID`
* `MachineId`
* `InstanceId`

## **Using PowerShell (Example for Machine ID spoofing)**

1. **Run PowerShell as Administrator**
Right-click PowerShell > *Run as administrator*

2. **(Optional) Backup the registry key**

```powershell
reg export "HKLM\SOFTWARE\AVG" "$env:USERPROFILE\Desktop\avg_backup.reg"
```

3. **Generate & Set New Fake ID**
Example (if `MachineId` exists and is a string):

```powershell
New-Guid | ForEach-Object { Set-ItemProperty -Path "HKLM:\SOFTWARE\AVG" -Name "MachineId" -Value $_.Guid }
```

## **Using CMD (Command Prompt)**

1. **Run as Administrator**
Right-click CMD > *Run as administrator*

2. **Generate & Set New ID (if string-based)**
Replace `MachineId` with the actual key name you want to spoof:

```cmd
for /f %g in ('powershell -command "[guid]::NewGuid().ToString()"') do reg add "HKLM\SOFTWARE\AVG" /v MachineId /t REG_SZ /d "%g" /f
```

⚠️ **Note**:

* Always back up the registry before making changes.
* AVG may revalidate IDs via online checks or reinstall.
