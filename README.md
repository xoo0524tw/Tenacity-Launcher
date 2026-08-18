# Tenacity Launcher

### Installation For New Users

1. Open the Tenacity Launcher GitHub repository.
2. Click the green `Code` button, then choose `Download ZIP`.
   - Direct download: <https://github.com/xoo0524tw/Tenacity-Launcher/archive/refs/heads/main.zip>
3. Extract the downloaded ZIP anywhere you want.
4. Open the extracted folder.
5. Double-click `Start Windows.bat`.
5.1 If you in Linux
   `chmod +x "./Start Linux.sh"`
   `"./Start Linux.sh"`
On the first launch, the launcher automatically checks GitHub Releases, downloads the latest `Tenacity.jar`, and starts Tenacity.

### Folder Layout

```text
Tenacity-Launcher/
  files/              Runtime files, Java, libs, natives, assets
  save/               Minecraft/Tenacity settings, accounts, screenshots, ViaMCP settings
  Tenacity.jar         Tenacity core, downloaded automatically after the first launch
  Start Windows.bat   Windows launcher script
```

Most users only need to double-click `Start Windows.bat`. Do not move or delete files inside `files/`.

### Auto Update

`Start Windows.bat` checks for updates before launching:


- If `Tenacity.jar` is missing, it downloads the latest version automatically.
- If GitHub Releases has a newer release tag, it updates `Tenacity.jar`.
- If the update check fails but a local `Tenacity.jar` exists, it launches the local version.
- If this is the first launch and the launcher cannot download `Tenacity.jar`, it stops and asks you to try again.

The release asset should be named `Tenacity.jar`. The launcher looks for this file first.

### Troubleshooting

**The launcher closes or does not download the core**

Make sure your connection can reach GitHub, and make sure the latest GitHub Release includes `Tenacity.jar`.

**Force the core to download again**

Delete `Tenacity.jar` and `save/Tenacity.version`, then run `Start Windows.bat` again.

**Where are my settings and screenshots**

All user data is stored inside `save/`.
