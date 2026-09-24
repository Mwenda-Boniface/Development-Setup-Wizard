# 02 // CLI Command Manual

`ghost-stack` provides a complete headless command-line interface suitable for script automation, CI/CD pipelines, and command-line power users.

---

## Command Reference

### 1. Interactive TUI Mode
```bash
ghost-stack
```
Launches the full interactive terminal user interface with glowing emerald aesthetic, numbered selection, and diagnostic frames.

---

### 2. Diagnostic Scans (`scan` or `-s`)
Runs check functions against installed packages and outputs status badges.

```bash
# Scan all categories across the entire machine:
ghost-stack scan

# Scan only Android and mobile tools:
ghost-stack scan android

# Scan only web development stack:
ghost-stack scan web

# Scan only AI & Machine Learning environment:
ghost-stack scan ai

# Scan only Developer Software & IDEs:
ghost-stack scan tools

# Scan Core System & DevOps:
ghost-stack scan core
```

*Exit Codes:* Returns `0` if all tools in the scanned category are verified; returns `1` if any tool is missing.

---

### 3. Headless Batch Installation (`install` or `-i`)
Installs uninstalled tools directly from the terminal without interactive prompts.

```bash
# Syntax: ghost-stack install <category> <indices|all>

# Install all missing tools in Web Development:
ghost-stack install web all

# Install specific missing tools in Web Development by index:
ghost-stack install web 1,3,4

# Install all missing AI/ML tools:
ghost-stack install ai all

# Install specific Android tools:
ghost-stack install android 1,2,5
```

---

### 4. Verification & Diagnostics (`doctor` or `-d`)
```bash
ghost-stack doctor
```
Runs `flutter doctor -v` and inspects Android SDK, Java 21, platform-tools, and desktop build toolchains.

---

### 5. System Integration (`install-cli`)
```bash
ghost-stack install-cli
```
Installs a symlink to `~/.local/bin/ghost-stack` (or `$PREFIX/bin/ghost-stack` on Termux), re-signs the desktop launcher checksum for the current user, and ensures environment variables are exported in `~/.zshrc` and `~/.bashrc`.

---

### 6. Linux System Cleaner & Diagnostics (`clean` or `cleaner`)
```bash
ghost-stack clean
```
Launches the full interactive Linux System Cleaner & Diagnostics suite. Automates cache pruning (`~/.cache`), system journal trimming (`journalctl --vacuum-size=200M`), APT package cache cleanup, `/tmp` temporary file clearing, Trash clearing, and full storage/hardware diagnostics.

Can also be invoked directly:
```bash
sudo make cleaner
# or
sudo ./system-cleaner.sh
```

---

### 6. In-Terminal Help Navigation Controls
When viewing any documentation topic inside the interactive viewer:
- `[ B ]`: Return to previous section (Help Index)
- `[ M ]`: Return to Main Menu
- `[ 0 / Q ]`: Exit Ghost-Stack completely
Accepted commands: `b`, `back`, `m`, `main`, `0`, `q`, `exit`, `quit`.

