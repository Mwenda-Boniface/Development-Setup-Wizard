# 04 // Troubleshooting & FAQ

## 1. "Untrusted Application Launcher" Warning on Double-Click
**Issue:** Double-clicking `Dev-Setup-Wizard.desktop` produces a prompt saying *"The desktop file is in an insecure location and not marked as secure"*.

**Solution:**
XFCE and Thunar require a security checksum metadata attribute. Run:
```bash
dev-wizard install-cli
```
Or execute:
```bash
gio set -t string ~/Desktop/Dev-Setup-Wizard.desktop metadata::xfce-exe-checksum "$(sha256sum ~/Desktop/Dev-Setup-Wizard.desktop | awk '{print $1}')"
```
Or simply click the button **"Mark As Secure And Launch"** on the prompt dialog once.

---

## 2. "command not found: dev-wizard"
**Issue:** Typing `dev-wizard` in a fresh terminal shell outputs `command not found`.

**Solution:**
Ensure `~/.local/bin` is in your shell `PATH`. Run:
```bash
export PATH="$HOME/.local/bin:$PATH"
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```
Or run `make install` from the repository directory.

---

## 3. Multiple ADB Binaries Warning in Flutter Doctor
**Issue:** `flutter doctor` prints:
```text
! Multiple adb binaries found:
    - ~/Android/Sdk/platform-tools/adb
    - /usr/lib/android-sdk/platform-tools/adb
```

**Solution:**
This is harmless and occurs when both system `adb` and Android SDK `platform-tools` are present. Ensure `~/Android/Sdk/platform-tools` is placed first in your `PATH` (which `dev-wizard` automatically configures).

---

## 4. Sudo Prompt During Installation
**Issue:** Installing system packages (`apt`) prompts for a sudo password.

**Solution:**
Packages installed via `apt` (like `docker.io`, `postgresql`, `clang`) require system-level administrator privileges. Tools such as Flutter, pip packages, and Android command-line tools are installed strictly in user space (`$HOME`) without requiring root.
