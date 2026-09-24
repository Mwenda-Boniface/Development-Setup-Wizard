# ==============================================================================
# Makefile for Dev-Wizard CLI & TUI Suite
# ==============================================================================

PREFIX ?= $(HOME)/.local
BINDIR ?= $(PREFIX)/bin
DESKTOPDIR ?= $(HOME)/.local/share/applications

.PHONY: all help install uninstall run scan doctor test

all: help

help:
	@echo "Dev-Wizard Build & Installation Targets:"
	@echo "  make install     - Install 'dev-wizard' command into $(BINDIR)"
	@echo "  make uninstall   - Remove 'dev-wizard' from $(BINDIR)"
	@echo "  make run         - Run interactive TUI directly"
	@echo "  make scan        - Run headless full system scan"
	@echo "  make doctor      - Run Flutter/Android doctor diagnostics"
	@echo "  make test        - Validate bash syntax of executable"

install:
	@mkdir -p $(BINDIR) $(DESKTOPDIR)
	@chmod +x bin/dev-wizard launch.sh
	@ln -sf $(CURDIR)/bin/dev-wizard $(BINDIR)/dev-wizard
	@cp Dev-Setup-Wizard.desktop $(DESKTOPDIR)/dev-setup-wizard.desktop 2>/dev/null || true
	@which update-desktop-database >/dev/null 2>&1 && update-desktop-database $(DESKTOPDIR) || true
	@echo "[OK] 'dev-wizard' successfully installed to $(BINDIR)/dev-wizard"
	@echo "You can now run 'dev-wizard' from anywhere in your terminal!"

uninstall:
	@rm -f $(BINDIR)/dev-wizard
	@rm -f $(DESKTOPDIR)/dev-setup-wizard.desktop
	@echo "[OK] 'dev-wizard' uninstalled."

run:
	@./bin/dev-wizard

scan:
	@./bin/dev-wizard scan

doctor:
	@./bin/dev-wizard doctor

test:
	@bash -n bin/dev-wizard
	@echo "[OK] Syntax check passed."
