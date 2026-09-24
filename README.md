# 🚀 Modular Dev-Environment Installer & Toolchain Manager

An interactive, terminal-based developer toolchain manager for Linux. It organizes developer tools by discipline, scans your system to detect what is already installed, and allows you to install multiple missing tools at once using comma-separated numbers (e.g. `1,2,5` or `A` for all).

---

## ⚡ How to Run

### Method 1: Double-Click
Double-click the **Dev Environment Setup Wizard** icon on your **Desktop** or inside this folder. An interactive terminal will immediately launch.

### Method 2: From Terminal
```bash
# Navigate to the folder in your project
cd ~/Desktop/WINK-DATING-APP/DevEnvironment-Installer
./run.sh
```

---

## 📂 Development Fields & Toolchains Supported

### 1. 🤖 Android Development
- **Java 21 LTS (OpenJDK)** (`JAVA_HOME` auto-configured)
- **Android Command-Line Tools** (`sdkmanager` without Android Studio)
- **Android Platform-Tools** (`adb` and `fastboot`)
- **Android SDK Platforms** (API 34 & 36)
- **Android Build-Tools** (28.0.3 & 34.0.0)
- **Flutter SDK** (Stable Channel)

### 2. 🍎 iOS Development (Linux Tools & Cross-Platform)
- **usbmuxd** (USB daemon for connecting iOS devices on Linux)
- **libimobiledevice** (Device communication library & inspection tools)
- **ideviceinstaller** (Install and manage apps on connected iOS devices)
- **CocoaPods** (Ruby-based iOS dependency manager)

### 3. 🌐 Web Development
- **Node.js LTS & npm**
- **pnpm & yarn** package managers
- **PostgreSQL** client and database server
- **Redis** in-memory store and CLI
- **Docker Engine & Docker Compose**
- **Chromium / Google Chrome** for web dev and browser testing

### 4. 🧠 AI & Machine Learning Development
- **Python 3, pip & venv** environment
- **Ollama** (Local LLM runner: Llama 3, DeepSeek, Gemma, Mistral)
- **Core AI/ML Stack** (PyTorch, NumPy, Pandas, Scikit-Learn, Matplotlib)
- **JupyterLab & Notebook** browser interface
- **Hugging Face Hub CLI** (`huggingface-cli`)

### 5. 💻 Development Softwares & IDEs
- **Visual Studio Code (VS Code)**
- **GitHub CLI (`gh`)**
- **Postman** (API Development & Testing Client)
- **DBeaver Community** (Universal Database GUI)
- **Git GUI Tools** (Git Cola & Gitk)
- **Tmux & Htop** (Terminal multiplexer & performance monitor)

### 6. 🔧 Core System Tools & Git / GitHub
- **Git CLI & Identity Config** (`user.name`, `user.email`, default branch `main`)
- **GitHub SSH Key Setup** (`~/.ssh/id_ed25519` + live connectivity test)
- **C/C++ Build Essentials** (`clang`, `cmake`, `ninja-build`, `pkg-config`, `libgtk-3-dev`)

---

## 🎯 How Selective Installation Works

1. Choose any category from the main menu (e.g. `[3] Web Development`).
2. The scanner runs instantly and badges every tool:
   - `[ ✓ INSTALLED     ]` (with details)
   - `[ ✗ NOT INSTALLED ]`
3. A numbered list of **only uninstalled tools** is presented.
4. Enter the tool numbers separated by commas to install them together:
   - Example: `1, 3`
   - Example: `1,2,4`
   - Or type `A` to install all missing tools in that field!
5. Environment variables are automatically synced and persisted into both `~/.zshrc` and `~/.bashrc`.
