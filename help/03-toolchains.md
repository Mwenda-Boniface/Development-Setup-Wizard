# 03 // Toolchain Catalog & Discipline Details

`ghost-stack` organizes modern software development tools into 6 primary disciplines:

---

## 1. Android Development (`android`)
- **Java 21 LTS (OpenJDK):** Modern LTS JDK for Android builds & Gradle.
- **Java 17 LTS (OpenJDK):** Legacy fallback JDK for older Android Gradle plugins.
- **Android Command-Line Tools (`sdkmanager`):** Google CLI SDK tools without needing Android Studio.
- **Android Platform-Tools (`adb`, `fastboot`):** USB debugging bridge and bootloader flashing tools.
- **Android SDK Platforms (API 34 & 36):** SDK headers and libraries for Android 14 and Android 16.
- **Android Build-Tools (28.0.3 & 34.0.0):** Compilers, `apksigner`, `zipalign`, and `d8`.
- **Android NDK:** Native C/C++ compiler and headers for JNI development.
- **Gradle Build Tool:** Standalone command-line build automation tool.
- **Flutter SDK:** Cross-platform framework for Android, Web, Desktop, and iOS.
- **Scrcpy:** High-performance Android screen mirroring and USB input control.

---

## 2. iOS Development (Linux Stack) (`ios`)
- **usbmuxd:** USB multiplexer daemon communicating with connected iPhone/iPad devices.
- **libimobiledevice:** Cross-platform software library and CLI suite (`ideviceinfo`, `idevicebackup`).
- **ideviceinstaller:** Command-line tool to install, test, and manage iOS apps over USB.
- **ifuse:** FUSE filesystem driver to mount iOS devices on Linux directories.
- **libplist-utils:** XML and binary property list conversion utilities.
- **CocoaPods & Ruby:** Dependency manager for cross-platform iOS libraries.
- **Fastlane:** Deployment and release automation pipeline.

---

## 3. Web Development (`web`)
- **Node.js LTS & npm:** Asynchronous event-driven JavaScript server runtime.
- **pnpm & yarn:** High-performance package managers with symlinked caching.
- **Bun:** Ultra-fast all-in-one JavaScript runtime, package manager, and bundler.
- **Deno:** Secure TypeScript/JavaScript runtime with native web standard APIs.
- **PostgreSQL:** Production-grade relational database server and `psql` client.
- **Redis:** In-memory key-value database, cache, and message broker.
- **SQLite3:** Embedded self-contained SQL database engine.
- **Docker Engine & Compose:** Containerization platform for modern cloud microservices.
- **Nginx:** High-performance web server, reverse proxy, and load balancer.
- **Google Chrome / Chromium:** Browser for web testing and headless Puppeteer automation.

---

## 4. AI & Machine Learning Development (`ai`)
- **Python 3, pip, venv & dev:** Base Python environment.
- **Ollama:** Local LLM runtime (run Llama 3, DeepSeek, Gemma, Mistral locally).
- **Core AI Stack:** NumPy, Pandas, SciPy, Matplotlib, Seaborn.
- **PyTorch:** GPU/CPU deep learning framework with Torchvision & Torchaudio.
- **Machine Learning Suite:** Scikit-Learn, XGBoost, LightGBM.
- **NLP & Transformers:** Hugging Face Transformers, Datasets, Tokenizers, Accelerate.
- **Vector Database:** ChromaDB & Sentence-Transformers for embeddings and RAG.
- **JupyterLab & Notebook:** Browser-based data science workspace.
- **Hugging Face Hub CLI:** Command-line model and dataset downloader.

---

## 5. Development Softwares & IDEs (`tools`)
- **Visual Studio Code:** Flagship extensible code editor.
- **GitHub CLI (`gh`):** Official command-line client for GitHub.
- **Postman:** API client for designing, testing, and mocking REST/GraphQL APIs.
- **Insomnia:** Lightweight modern REST and GraphQL client.
- **DBeaver Community:** Universal database GUI supporting SQL, PostgreSQL, SQLite, etc.
- **Lazygit:** Terminal UI for Git commands.
- **Git GUI Tools:** Git Cola and Gitk for graphical branch navigation.
- **Neovim:** High-performance extensible terminal text editor.
- **Tmux & Htop:** Terminal multiplexer and system performance monitors.

---

## 6. Core System Tools & DevOps (`core`)
- **Git Identity & Configuration:** Global name, email, and default branch settings.
- **GitHub SSH Key:** Automated Ed25519 key generation and connection verification.
- **C/C++ Build Essentials:** `gcc`, `g++`, `clang`, `cmake`, `ninja-build`, `pkg-config`, `libgtk-3-dev`.
- **Rust Toolchain:** `rustup`, `rustc`, `cargo`.
- **Go Programming Language:** `golang` runtime and compiler.
- **Modern CLI Utilities:** `jq`, `ripgrep`, `fzf`.
- **Network Security Utilities:** `nmap`, `netcat`, `tcpdump`.
