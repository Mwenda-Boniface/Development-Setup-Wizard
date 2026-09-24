# DEV-WIZARD // System & Toolchain Orchestrator

[![Linux](https://img.shields.io/badge/Platform-Linux-0078D7?logo=linux&logoColor=white)](#)
[![Bash](https://img.shields.io/badge/Shell-Bash_4.4+-4EAA25?logo=gnubash&logoColor=white)](#)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](#)

A modular, terminal-based developer toolchain orchestrator engineered for Linux systems. Features dual-mode execution (Interactive Terminal UI and Headless CLI for automation), automatic system state detection, and batch multi-tool provisioning.

> **Architecture Documentation:** See [`implementation.md`](file:///home/bonnie/Desktop/setup-wizard/implementation.md) for full system architecture, component breakdown, and design specifications.

---

## Quick Start for Tech Gurus

### 1. Clone & Global CLI Installation
```bash
git clone git@github.com:Mwenda-Boniface/Development-Setup-Wizard.git setup-wizard
cd setup-wizard

# Install globally to ~/.local/bin:
make install
```

Once installed, `dev-wizard` is accessible from any terminal window across your system.

---

## CLI Command Interface

```bash
# 1. Launch Interactive TUI
dev-wizard

# 2. Run Headless Diagnostic Scans
dev-wizard scan            # Full scan across all categories
dev-wizard scan android    # Check Android & Flutter toolchain
dev-wizard scan web        # Check Web stack (Node, PostgreSQL, Redis, Docker)
dev-wizard scan ai         # Check AI & Python ML environment

# 3. Headless Batch Installation
dev-wizard install web 1,3     # Install specific uninstalled tools
dev-wizard install ai all      # Install all missing AI packages
dev-wizard install android all # Provision complete Android CLI SDK

# 4. Diagnostics & Verification
dev-wizard doctor          # Run Flutter & Android toolchain doctor
dev-wizard --help          # View full CLI manual
dev-wizard --version       # Check installed version
```

---

## Supported Disciplines & Toolchains

| Code | Discipline | Included Tools |
|---|---|---|
| **01** | **Android Development** | Java 21 LTS (OpenJDK), Android `cmdline-tools` (`sdkmanager`), `platform-tools` (`adb`), SDK Platforms 34/36, Build-Tools 28.0.3/34.0.0, Flutter SDK (Stable) |
| **02** | **iOS Development (Linux)** | `usbmuxd`, `libimobiledevice`, `ideviceinstaller`, CocoaPods & Ruby stack |
| **03** | **Web Development** | Node.js LTS, npm, pnpm, yarn, PostgreSQL server & client, Redis, Docker Engine, Docker Compose, Chromium |
| **04** | **AI & Machine Learning** | Python 3, pip, venv, Ollama (Local LLM runner), PyTorch, NumPy, Pandas, Scikit-Learn, JupyterLab, Hugging Face CLI |
| **05** | **Development Softwares** | Visual Studio Code, GitHub CLI (`gh`), Postman, DBeaver Community, Git Cola, Tmux, Htop |
| **06** | **Core System & Git** | Git identity, GitHub SSH Key (~/.ssh/id_ed25519), C/C++ Build Essentials (`clang`, `cmake`, `ninja`, `pkg-config`) |

---

## Desktop Launch (GUI)

- Double-click the **Dev Environment Setup Wizard** launcher icon on your Desktop or run:
```bash
./launch.sh
```
*(Automatically detects QTerminal, GNOME Terminal, or XFCE Terminal).*
