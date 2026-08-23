# WSA Link Fixer 🔗

> **Fix for links not opening in Windows due to Windows Subsystem for Android (WSA) conflicts.**

[![License: MIT](https://img.shields.io/badge/License-MIT-red.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/Platform-Windows%2011-blue)](https://www.microsoft.com/windows)

## 🛑 The Problem

If you use **Windows Subsystem for Android** (especially custom builds like **WSABuilds**, MagiskOnWSA, or MustardChef), you might encounter this issue:

- You click a link in **WhatsApp Desktop**, **VS Code**, **Discord**, or **Slack**.
- **Nothing happens**, or a loading cursor appears for a split second.
- The link does **not** open in your default browser (Chrome, Edge, Firefox).
- The system is trying to open the link inside an Android app but failing.

This happens because WSA registers itself as a handler for `http` and `https` protocols, "hijacking" the links from Windows.

## ✅ The Solution

This simple PowerShell script detects the conflicting registry key created by WSA (`AppUriHandlers`) and safely renames it. This forces Windows to ignore Android for web links and revert to your default browser.

It is **non-destructive**: it creates a timestamped backup of the registry key instead of deleting it.

## 🚀 How to Use

1. **Download** the latest release:
   - [Click here to download `wsa-link-fixer.zip`](https://github.com/dvdzhou/wsa-link-fixer/releases/latest/download/wsa-link-fixer.zip)
   - Extract the `.zip` archive.

2. **Run the tool**:
   - Double-click **`run_script.bat`**.
   - *(If Windows Defender SmartScreen appears, click **More info** ➔ **Run anyway**, or right-click the `.zip` ➔ **Properties** ➔ check **Unblock** before extracting).*

3. **Follow the on-screen instructions**:
   - The script will ask to close WSA automatically.
   - It will back up and rename the conflicting key.
   - It will restart Windows Explorer to apply changes instantly.

## 🛠 Manual Fix (If you prefer not to use the script)

If you want to do this manually:
1. Open Registry Editor (`regedit`).
2. Navigate to: 
   `HKEY_CURRENT_USER\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppModel\SystemAppData\MicrosoftCorporationII.WindowsSubsystemForAndroid_8wekyb3d8bbwe\AppUriHandlers`
3. Delete or rename the `AppUriHandlers` folder.
4. Restart your PC or the Windows Explorer process.

## ⚠️ Disclaimer

This script is provided "as is". While it only modifies a specific user-level registry key related to app associations, always ensure you have backups of your important data.

## 🤝 Credits

This tool is based on the solution shared by [@TheShark27](https://github.com/TheShark27) in the official Microsoft WSA repository.
You can find the original discussion here: [microsoft/WSA#361](https://github.com/microsoft/WSA/issues/361)

## 📄 License

MIT License. Feel free to fork and improve.
