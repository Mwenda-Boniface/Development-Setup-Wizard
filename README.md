# GHOST-STACK // System & Toolchain Orchestrator

[![Linux](https://img.shields.io/badge/Platform-Linux-0078D7?logo=linux&logoColor=white)](#)
[![Bash](https://img.shields.io/badge/Shell-Bash_4.4+-4EAA25?logo=gnubash&logoColor=white)](#)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](#)

```text
   ________               __       _____ __             __  
  / ____/ /_  ____  _____/ /_     / ___// /_____ ______/ /__
 / / __/ __ \/ __ \/ ___/ __/_____\__ \/ __/ __ `/ ___/ //_/
/ /_/ / / / / /_/ (__  ) /_/_____/__/ / /_/ /_/ / /__/ ,<   
\____/_/ /_/\____/____/\__/     /____/\__/\__,_/\___/_/|_|  

       [ + ]   C O D E   B Y   M W E N D A   B O N I F A C E   [ + ]
```

A modular, terminal-based developer toolchain orchestrator engineered for Linux systems. Features dual-mode execution (Interactive Terminal UI and Headless CLI for automation), automatic system state detection, and batch multi-tool provisioning.

> **Architecture Documentation:** See [`implementation.md`](file:///home/bonnie/Desktop/setup-wizard/implementation.md) for full system architecture, component breakdown, and design specifications.  
> **Help Center:** See [`help/`](file:///home/bonnie/Desktop/setup-wizard/help/) for detailed, colored terminal navigation guides.

---

## Quick Start for Tech Gurus

### 1. Clone & Global CLI Installation
```bash
git clone git@github.com:Mwenda-Boniface/Development-Setup-Wizard.git setup-wizard
cd setup-wizard

# Install globally into ~/.local/bin:
make install
```

Once installed, `ghost-stack` (and alias `dev-wizard`) is accessible from any terminal window across your system.

---

## CLI Command Interface

```bash
# 1. Launch Interactive TUI
ghost-stack

# 2. Run Headless Diagnostic Scans
ghost-stack scan            # Full scan across all categories
ghost-stack scan android    # Check Android & Flutter toolchain
ghost-stack scan web        # Check Web stack (Node, PostgreSQL, Redis, Docker)
ghost-stack scan ai         # Check AI & Python ML environment

# 3. Headless Batch Installation
ghost-stack install web 1,3     # Install specific uninstalled tools
ghost-stack install ai all      # Install all missing AI packages
ghost-stack install android all # Provision complete Android CLI SDK

# 4. Diagnostics & Verification
ghost-stack doctor          # Run Flutter & Android toolchain doctor
ghost-stack --help          # View full CLI manual
ghost-stack --version       # Check installed version
```

---

## Supported Disciplines & Toolchains

| Code | Discipline | Included Tools |
|---|---|---|
| **01** | **Android Development** | Java 21 LTS, Java 17 LTS, Android `cmdline-tools` (`sdkmanager`), `platform-tools` (`adb`), SDK Platforms 34/36, Build-Tools 28.0.3/34.0.0, Android NDK, Gradle, Flutter SDK (Stable), Scrcpy |
| **02** | **iOS Development (Linux)** | `usbmuxd`, `libimobiledevice`, `ideviceinstaller`, `ifuse`, `libplist-utils`, CocoaPods & Ruby, Fastlane |
| **03** | **Web Development** | Node.js LTS, npm, pnpm, yarn, Bun, Deno, PostgreSQL, Redis, SQLite3, Docker Engine, Docker Compose, Nginx, Chromium |
| **04** | **AI & Machine Learning** | Python 3, pip, venv, Ollama (Local LLM runner), PyTorch, NumPy, Pandas, Scikit-Learn, Transformers, ChromaDB, JupyterLab, Hugging Face CLI |
| **05** | **Development Softwares** | Visual Studio Code, GitHub CLI (`gh`), Postman, Insomnia, DBeaver Community, Lazygit, Git Cola, Neovim, Tmux & Htop |
| **06** | **Core System & DevOps** | Git identity, GitHub SSH Key (~/.ssh/id_ed25519), C/C++ Build Essentials, Rust, Go, jq, ripgrep, fzf, Nmap, Netcat |

---

## Desktop Launch (GUI)

- Double-click the **Dev Environment Setup Wizard** launcher icon on your Desktop or run:
```bash
./launch.sh
```
*(Automatically detects QTerminal, GNOME Terminal, or XFCE Terminal without hardcoded usernames).*
