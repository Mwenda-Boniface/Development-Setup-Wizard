# 01 // Getting Started with Ghost-Stack

## Overview
**Ghost-Stack** is a modular developer environment and toolchain manager tailored for modern Linux distributions (Kali, Debian, Ubuntu, Linux Mint, Pop!_OS). It eliminates tedious manual environment setup by automatically scanning your system, identifying missing toolchains, and installing selected dependencies with a single command.

---

## Installation & Setup Methods

### Method 1: Global CLI Access (Recommended)
After cloning the repository, install `ghost-stack` globally into your user bin:

```bash
cd setup-wizard
make install
```

This creates a symlink at `~/.local/bin/ghost-stack` and registers desktop entry shortcuts. Once completed, `ghost-stack` can be invoked from any terminal window across your system.

### Method 2: Direct Execution
You can run the binary directly from the cloned repository without installing:
```bash
./bin/ghost-stack
```
Or use the convenience root launcher:
```bash
./run.sh
```

### Method 3: Desktop Launcher (GUI Double-Click)
Double-click the **Ghost-Stack Dev Setup Wizard** icon on your Desktop or run:
```bash
./launch.sh
```
`launch.sh` automatically detects your installed desktop terminal emulator (QTerminal, GNOME Terminal, or XFCE Terminal) and opens an interactive window.

### Method 4: Android (Termux) Execution
Ghost-Stack runs natively on Android via Termux without requiring root:
```bash
pkg update && pkg install -y git bash make
git clone https://github.com/Mwenda-Boniface/Development-Setup-Wizard.git setup-wizard
cd setup-wizard
./run.sh
# Or install globally into $PREFIX/bin:
make install
ghost-stack
```

---

## Dynamic User Resolution
`ghost-stack` is completely user-agnostic:
- It discovers the current active user via `$(id -un)` and home via `$HOME`.
- No paths are hardcoded to any specific developer account.
- Desktop files and environment variable blocks (`~/.zshrc` and `~/.bashrc`) automatically adapt to whoever is logged in.

---

## Navigation Controls
While viewing any section inside the Help Documentation:
- `[ B ]`: Return to Help Menu
- `[ M ]`: Jump directly to Main Menu
- `[ 0 / Q ]`: Exit Ghost-Stack completely
