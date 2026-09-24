# GHOST-STACK // System & Toolchain Orchestrator

[![Linux](https://img.shields.io/badge/Platform-Linux-0078D7?logo=linux&logoColor=white)](#)
[![Android Termux](https://img.shields.io/badge/Platform-Android_Termux-000000?logo=android&logoColor=white)](#)
[![Shell](https://img.shields.io/badge/Shell-Bash_4.4+-4EAA25?logo=gnubash&logoColor=white)](#)
[![Aesthetics](https://img.shields.io/badge/Style-Cyberpunk_Terminal_Green-38EF7D)](#)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](#)

```text
   ________               __       _____ __             __  
  / ____/ /_  ____  _____/ /_     / ___// /_____ ______/ /__
 / / __/ __ \/ __ \/ ___/ __/_____\__ \/ __/ __ `/ ___/ //_/
/ /_/ / / / / /_/ (__  ) /_/_____/__/ / /_/ /_/ / /__/ ,<   
\____/_/ /_/\____/____/\__/     /____/\__/\__,_/\___/_/|_|  

       [ + ]   C O D E   B Y   M W E N D A   B O N I F A C E   [ + ]
```

A modular, terminal-based developer toolchain orchestrator engineered for modern **Linux distributions** (Kali, Debian, Ubuntu, Linux Mint, Pop!_OS) and **Android Termux**. Features dual-mode operation (an immersive Cyberpunk Terminal UI and an exhaustive Headless CLI for automation), automatic system state detection, dynamic multi-user isolation, and batch multi-tool provisioning with zero emojis.

> **Architecture Documentation:** See [`implementation.md`](file:///home/bonnie/Desktop/setup-wizard/implementation.md) for architectural blueprints, telemetry design, and component breakdown.  
> **Help Center:** See [`help/`](file:///home/bonnie/Desktop/setup-wizard/help/) for in-depth, styled terminal guides and troubleshooting manuals.

---

## Quick Installation & Setup

### 1. Global Installation (Linux & Android Termux)
Clone the repository and install `ghost-stack` into your system binary path:

```bash
git clone https://github.com/Mwenda-Boniface/Development-Setup-Wizard.git setup-wizard
cd setup-wizard

# Install globally (into ~/.local/bin on Linux or $PREFIX/bin on Termux):
make install
```

Once installed, `ghost-stack` (along with its legacy alias `dev-wizard`) is immediately accessible from any terminal window across your system.

---

## Execution Modes

`ghost-stack` provides two operational workflows:
1. **Interactive TUI Mode:** Designed for developers who prefer an interactive menu with real-time detection, live status badges, and selective installation.
2. **Headless CLI Mode:** Designed for power users, DevOps engineers, and automated CI/CD scripts who want to execute direct commands without interactive prompts.

---

## 1. Interactive Mode (Terminal UI)

To launch the interactive cyber terminal interface, run:

```bash
ghost-stack
```

*Or from within the cloned directory without installing:*
```bash
./run.sh
```

### What the Interactive Interface Provides:
- **Telemetry Header:** Aircrack-ng style initialization telemetry showing host architecture, kernel OS, package manager, and active user.
- **Real-Time Verification:** Automatically checks every tool in the selected discipline and displays status badges (`[ OK ]` in green or `[ MISSING ]` in red).
- **Batch Selective Installation:** Prompts you to install missing tools by entering comma-separated numbers (e.g. `1,2,5`), typing `A` to install all missing tools, or typing `R` to force reinstall existing tools.
- **Embedded Help Center:** Press `H` to read the built-in documentation manual with instant return (`B`), jump to main menu (`M`), or exit (`0 / Q`).

---

## 2. Headless CLI Mode (Command Reference)

For tech gurus and automation scripts who prefer direct command-line execution, `ghost-stack` offers an extensive suite of commands:

| Command | Synopsis | What It Does |
|---|---|---|
| `ghost-stack` | `ghost-stack` | Launches the interactive Terminal UI menu. |
| `ghost-stack scan` | `ghost-stack scan [discipline]` | Executes an automated diagnostic scan across all 6 disciplines (or a specific discipline) and prints verified vs missing tools. |
| `ghost-stack install` | `ghost-stack install <discipline> <items\|all>` | Performs direct, headless batch provisioning of tools by index (e.g. `1,3,4`) or all uninstalled tools (`all`). |
| `ghost-stack doctor` | `ghost-stack doctor` | Runs Flutter Doctor and inspects Android SDK, Java versions, platform-tools (`adb`), and build toolchains. |
| `ghost-stack list` | `ghost-stack list [discipline]` | Lists all registered toolchains and their associated verification routines. |
| `ghost-stack install-cli` | `ghost-stack install-cli` | Symlinks `ghost-stack` globally, exports environment variables into `~/.zshrc`/`~/.bashrc`, and signs desktop entries. |
| `ghost-stack help` | `ghost-stack help [topic]` | Renders styled terminal documentation topics (`getting-started`, `commands`, `toolchains`, `troubleshooting`). |
| `ghost-stack --version` | `ghost-stack -v` | Displays engine version, target OS platform, and machine architecture. |
| `ghost-stack --help` | `ghost-stack -h` | Displays the standard UNIX man-page usage synopsis. |

### CLI Usage Examples:

```bash
# Perform a full diagnostic scan across all 6 disciplines
ghost-stack scan

# Perform a targeted scan for Android and Flutter tools
ghost-stack scan android

# Perform a targeted scan for Web tools (Node, Docker, DBs)
ghost-stack scan web

# Install all missing tools in the AI & Machine Learning stack
ghost-stack install ai all

# Install specific uninstalled Web tools (e.g. tools #1, #3, and #4)
ghost-stack install web 1,3,4

# Install all uninstalled Android development tools
ghost-stack install android all

# Run deep Flutter & Android toolchain doctor diagnostics
ghost-stack doctor

# Read the CLI manual directly inside the terminal
ghost-stack help commands
```

---

## 3. Running on Android (Termux Support)

`ghost-stack` is engineered to run seamlessly on Android devices via **Termux** without requiring root privileges.

### Prerequisites in Termux:
```bash
pkg update && pkg install -y git bash make
```

### Installation & Execution in Termux:
```bash
git clone https://github.com/Mwenda-Boniface/Development-Setup-Wizard.git setup-wizard
cd setup-wizard

# Run directly:
./run.sh

# Or install globally into Termux's $PREFIX/bin:
make install
ghost-stack
```

### Termux-Specific Features:
- **Rootless Package Management:** Automatically wraps `pkg install` and `apt-get install` without invoking `sudo`.
- **Dynamic Paths:** Relocates temporary directories to `$PREFIX/tmp` or `$HOME/.tmp` instead of inaccessible `/tmp`.
- **Native Android Tools:** Provisions native `android-tools` (`adb`, `fastboot`), OpenJDK 17, Python, Node.js, and compiler toolchains compiled specifically for Android bionic libc.
- **Desktop Guard:** Automatically bypasses FreeDesktop launcher and GUI signing logic when running inside Termux.

---

## Supported Disciplines & Toolchains

| Code | Discipline | Included Toolchains & Packages |
|---|---|---|
| **01** | **Android Development** | Java 21 LTS, Java 17 LTS, Android `cmdline-tools` (`sdkmanager`), `platform-tools` (`adb`, `fastboot`), SDK Platforms 34/36, Build-Tools (28.0.3 & 34.0.0), Android NDK, Gradle Build Tool, Flutter SDK (Stable), Scrcpy |
| **02** | **iOS Development (Linux)** | `usbmuxd` (USB daemon), `libimobiledevice` (`ideviceinfo`), `ideviceinstaller`, `ifuse` (FUSE mount), `libplist-utils`, CocoaPods & Ruby, Fastlane |
| **03** | **Web Development** | Node.js LTS, npm, pnpm, yarn, Bun, Deno, PostgreSQL Server & Client, Redis Server & CLI, SQLite3 & Headers, Docker Engine, Docker Compose, Nginx, Chromium |
| **04** | **AI & Machine Learning** | Python 3, pip, venv, Ollama (Local LLM runner), PyTorch, NumPy, Pandas, SciPy, Matplotlib, Scikit-Learn, Transformers, ChromaDB, JupyterLab, Hugging Face CLI |
| **05** | **Development Softwares** | Visual Studio Code / Code-Server, GitHub CLI (`gh`), Postman API Client, Insomnia REST Client, DBeaver Universal Database GUI, Lazygit, Git Cola, Neovim, Tmux & Htop |
| **06** | **Core System & DevOps** | Git identity setup, GitHub SSH Key (`~/.ssh/id_ed25519`), C/C++ Build Essentials (GCC, Clang, CMake, Ninja), Rust & Cargo, Go (Golang), jq, ripgrep, fzf, Nmap, Netcat |

---

## Desktop Launch (GUI)

On desktop Linux environments (GNOME, XFCE, KDE, Kali):
- Double-click the **Ghost-Stack Dev Setup Wizard** icon on your Desktop.
- Or execute:
  ```bash
  ./launch.sh
  ```
`launch.sh` auto-detects your desktop terminal emulator (`qterminal`, `gnome-terminal`, `xfce4-terminal`, or `x-terminal-emulator`) and launches the wizard in a dedicated terminal window.

---

## Dynamic User Resolution & Security

`ghost-stack` adheres to strict security and multi-user isolation standards:
- **No Hardcoded Usernames:** Determines the active executor via `$(id -un)` and `$HOME`.
- **Dynamic Checksum Stamping:** Automatically hashes desktop launchers and signs them with XFCE/Thunar trusted metadata (`metadata::xfce-exe-checksum`), preventing untrusted launcher prompts.
- **Isolated User Environments:** Installs user-space SDKs (Flutter, Android SDK, Cargo, Bun, Deno, Python venv) cleanly inside `$HOME` without polluting system-wide directories.

---

## Contributing & License

Contributions, feature requests, and bug reports are welcome via GitHub issues and pull requests.

Distributed under the **MIT License**. Engineered with precision by **Mwenda Boniface** ([@Mwenda-Boniface](https://github.com/Mwenda-Boniface)).
