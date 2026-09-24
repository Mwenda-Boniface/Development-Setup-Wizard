# ==============================================================================
# Makefile for Ghost-Stack CLI & TUI Suite
# Platform: Linux (Debian/Ubuntu/Kali) & Android (Termux)
# ==============================================================================

# Detect Termux vs Standard Linux
ifneq ($(wildcard /data/data/com.termux),)
  PREFIX ?= /data/data/com.termux/files/usr
  BINDIR ?= $(PREFIX)/bin
else
  PREFIX ?= $(HOME)/.local
  BINDIR ?= $(PREFIX)/bin
endif
DESKTOPDIR ?= $(HOME)/.local/share/applications

.PHONY: all help install uninstall run scan doctor test

all: help

help:
	@echo "Ghost-Stack Build & Installation Targets:"
	@echo "  make install     - Install 'ghost-stack' into $(BINDIR)"
	@echo "  make uninstall   - Remove 'ghost-stack' from $(BINDIR)"
	@echo "  make run         - Run interactive TUI directly"
	@echo "  make scan        - Run headless full system scan"
	@echo "  make doctor      - Run Flutter/Android doctor diagnostics"
	@echo "  make test        - Validate bash syntax of executable"

install:
	@mkdir -p $(BINDIR)
	@chmod +x bin/ghost-stack launch.sh run.sh
	@ln -sf $(CURDIR)/bin/ghost-stack $(BINDIR)/ghost-stack
	@if [ ! -d "/data/data/com.termux" ]; then \
		mkdir -p $(DESKTOPDIR); \
		cp Ghost-Stack.desktop $(DESKTOPDIR)/ghost-stack.desktop 2>/dev/null || true; \
		which update-desktop-database >/dev/null 2>&1 && update-desktop-database $(DESKTOPDIR) || true; \
	fi
	@echo "[OK] 'ghost-stack' successfully installed to $(BINDIR)/ghost-stack"
	@echo "You can now run 'ghost-stack' from anywhere in your terminal!"

uninstall:
	@rm -f $(BINDIR)/ghost-stack $(BINDIR)/dev-wizard
	@rm -f $(DESKTOPDIR)/ghost-stack.desktop $(DESKTOPDIR)/dev-setup-wizard.desktop
	@echo "[OK] 'ghost-stack' uninstalled."

run:
	@./bin/ghost-stack

scan:
	@./bin/ghost-stack scan

doctor:
	@./bin/ghost-stack doctor

test:
	@bash -n bin/ghost-stack
	@echo "[OK] Syntax check passed."
