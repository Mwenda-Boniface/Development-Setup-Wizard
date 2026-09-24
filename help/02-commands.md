# 02 // CLI Command Manual

`dev-wizard` provides a complete headless command-line interface suitable for script automation, CI/CD pipelines, and command-line power users.

---

## Command Reference

### 1. Interactive TUI Mode
```bash
dev-wizard
```
Launches the full interactive terminal user interface with glowing emerald aesthetic, numbered selection, and diagnostic frames.

---

### 2. Diagnostic Scans (`scan` or `-s`)
Runs check functions against installed packages and outputs status badges.

```bash
# Scan all categories across the entire machine:
dev-wizard scan

# Scan only Android and mobile tools:
dev-wizard scan android

# Scan only web development stack:
dev-wizard scan web

# Scan only AI & Machine Learning environment:
dev-wizard scan ai

# Scan only Developer Software & IDEs:
dev-wizard scan tools

# Scan Core System & DevOps:
dev-wizard scan core
```

*Exit Codes:* Returns `0` if all tools in the scanned category are verified; returns `1` if any tool is missing.

---

### 3. Headless Batch Installation (`install` or `-i`)
Installs uninstalled tools directly from the terminal without interactive prompts.

```bash
# Syntax: dev-wizard install <category> <indices|all>

# Install all missing tools in Web Development:
dev-wizard install web all

# Install specific missing tools in Web Development by index:
dev-wizard install web 1,3,4

# Install all missing AI/ML tools:
dev-wizard install ai all

# Install specific Android tools:
dev-wizard install android 1,2,5
```

---

### 4. Verification & Diagnostics (`doctor` or `-d`)
```bash
dev-wizard doctor
```
Runs `flutter doctor -v` and inspects Android SDK, Java 21, platform-tools, and desktop build toolchains.

---

### 5. System Integration (`install-cli`)
```bash
dev-wizard install-cli
```
Installs a symlink to `~/.local/bin/dev-wizard`, re-signs the desktop launcher checksum for the current user, and ensures environment variables are exported in `~/.zshrc` and `~/.bashrc`.
