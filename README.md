# Sinhala Font Changer for Linux

A user-friendly bash script to configure system-wide Sinhala font preferences on Linux systems using fontconfig. Change your Sinhala font rendering with a single command—no manual configuration editing required.

## ✨ Features

- **Interactive font selection** — Choose from 4 pre-bundled Sinhala fonts
- **User-level installation** — No root/sudo required; changes apply per-user
- **Automatic font installation** — Fonts are installed to `~/.local/share/fonts/` if not already present
- **Live preview** — Opens a test document showing Sinhala text in your selected font
- **Modern fontconfig integration** — Compatible with Ubuntu 24.04 LTS / Linux Mint 22.x (fontconfig 2.15+)

## 📦 Included Fonts

1. **Noto Sans Sinhala** — Modern, clean sans-serif font by Google
2. **Noto Serif Sinhala** — Traditional serif font for formal documents
3. **UN-Gurulugomi** — Classic Sinhala font widely used in educational contexts
4. **tuxSinhala Bold** — Bold variant for emphasis and headings

All fonts are licensed under the SIL Open Font License (OFL) — see [`LICENSE_OFL.txt`](LICENSE_OFL.txt) for details.

## 🖥️ Compatibility

**Tested on:**
- ✅ Linux Mint 22.3 (x86_64)
- ✅ Ubuntu 24.04 LTS
- ✅ Ubuntu 22.04 LTS

**Requirements:**
- `bash` (4.0+)
- `fontconfig` (2.14+)
- `sed`, `tput`, `xdg-open` (pre-installed on most distros)

The script automatically checks for required dependencies on startup.

## 🚀 Usage

1. **Clone the repository:**
   ```bash
   git clone https://github.com/optimuspnj/linux-sinhala-font-changer.git
   cd linux-sinhala-font-changer
   ```

2. **Run the script:**
   ```bash
   bash font-changer.sh
   ```

3. **Follow the prompts:**
   - Select your preferred font (1-4)
   - The script will install the font and configure fontconfig
   - A test document will open showing Sinhala text in your new font

4. **Verify the change:**
   ```bash
   LANG=si fc-match
   ```
   This should display your selected font as the primary Sinhala font.

## 🔧 How It Works

The script performs three operations:

1. **Font Installation**  
   Copies font files to `~/.local/share/fonts/sinhala-font-changer/[Font Name]/`

2. **Fontconfig Configuration**  
   Generates `~/.config/fontconfig/conf.d/50-si-custom.conf` that tells fontconfig to prefer your selected font for Sinhala text (language code: `si`)

3. **Cache Refresh**  
   Runs `fc-cache -f` to rebuild the font cache

The configuration applies to all applications that use fontconfig (web browsers, LibreOffice, GNOME apps, etc.). Changes take effect immediately for new applications; running apps may need a restart.

## 🔄 Changing Fonts

To switch to a different Sinhala font, simply run the script again:

```bash
bash font-changer.sh
```

Your previous font selection will be replaced with the new one.

## 🐛 Troubleshooting

**Font not changing in Firefox/Chrome?**
- Restart the browser completely (close all windows)
- Check if the font is properly installed: `fc-list | grep -i sinhala`

**"Command not found" errors?**
- Ensure you're on a Debian/Ubuntu-based distro with fontconfig installed
- Install missing dependencies: `sudo apt install fontconfig`

**Sinhala text still shows boxes (□□□)?**
- Your system may be missing Sinhala language support
- Install: `sudo apt install fonts-sinhala language-pack-si`

## 📝 Manual Configuration

The generated fontconfig file is located at:
```
~/.config/fontconfig/conf.d/50-si-custom.conf
```

You can manually edit this file to customize font preferences. After editing, run:
```bash
fc-cache -f
```

## 🤝 Contributing

Contributions are welcome! If you encounter issues or want to add more fonts:

1. Open an [issue](https://github.com/optimuspnj/linux-sinhala-font-changer/issues)
2. Submit a pull request with font additions or bug fixes

**Note:** This is a fork of [hankyoTutorials/linux-system-sinhala-font-changer](https://github.com/hankyoTutorials/linux-system-sinhala-font-changer) with compatibility improvements for Ubuntu 24.04 / Linux Mint 22.3.

## 📄 License

- **Script:** MIT License — see [`LICENSE`](LICENSE)
- **Fonts:** SIL Open Font License (OFL) — see [`LICENSE_OFL.txt`](LICENSE_OFL.txt) and [`UN-Gurulugomi-font-license-info`](UN-Gurulugomi-font-license-info)

## 🙏 Acknowledgments

- Google Fonts for Noto Sans/Serif Sinhala
- UN ICG for UN-Gurulugomi
- The fontconfig project for excellent font management tools

---

**සුභ දවසක් වේවා!** (Have a great day!)
