# Arch Linux Workstation Infrastructure

A reproducible, Infrastructure-as-Code approach to building and maintaining a personal Arch Linux workstation.

This repository contains package manifests, application configuration, deployment scripts, validation tooling, and continuous integration for a Hyprland-based desktop environment.

---

## Overview

The goal of this project is to reduce manual workstation configuration by treating a Linux desktop like production infrastructure:

- Version controlled
- Documented
- Automated
- Reproducible
- Validated
- Easy to rebuild

Instead of relying on memory or one-off setup steps, the workstation is defined through source-controlled configuration and repeatable scripts.

---

## Project Status

This project is under active development.

The core deployment architecture is implemented:

- Official Arch package installation
- AUR package installation through `paru`
- Configuration deployment with managed symlinks
- Automatic backup of conflicting configuration
- Bootstrap orchestration
- Helper-command installation
- Configuration-link validation
- ShellCheck continuous integration

The following areas are still in progress:

- Complete dependency auditing
- Expanded workstation health validation
- Clean-VM deployment testing
- Idempotency and recovery testing
- Bare-metal deployment

---

## Architecture

```text
                  GitHub
                     │
                     ▼
          Arch Linux Base Install
                     │
                     ▼
           Package Installation
            ├── Arch packages
            └── AUR packages
                     │
                     ▼
          Configuration Deployment
            ├── Existing config backup
            └── Managed symlinks
                     │
                     ▼
            Workstation Setup
            ├── Fonts
            ├── Themes
            └── Services
                     │
                     ▼
            Deployment Validation
                     │
                     ▼
          Hyprland Workstation
```

The complete workflow is orchestrated by `scripts/bootstrap.sh`.

```text
bootstrap.sh
    │
    ├── install.sh
    ├── deploy-configs.sh
    ├── fonts.sh
    ├── themes.sh
    ├── services.sh
    └── validate.sh
```## Validation

The current validation script checks every directory under `configs/`.

For each managed configuration, it verifies that:

1. The corresponding target under `~/.config` is a symlink.
2. The symlink resolves to the expected repository directory.

Run validation with:

```bash
./scripts/validate.sh
```

or, after helper commands are installed:

```bash
workstation-validate
```

Current validation is intentionally limited to configuration deployment. Package, command, service, font, theme, and runtime checks are planned.


Some setup stages are currently placeholders and are documented in the roadmap.

---

## Repository Structure

```text
arch-workstation/
├── .github/
│   └── workflows/
│       └── shellcheck.yml
│
├── configs/
│   ├── bash/
│   ├── btop/
│   ├── foot/
│   ├── git/
│   ├── hypr/
│   ├── hypridle/
│   ├── hyprlock/
│   ├── hyprpaper/
│   ├── mako/
│   ├── rofi/
│   └── waybar/
│
├── config/
│   ├── dependencies/
│   │   └── default.conf
│   └── services/
│       └── default.conf
│
├── packages/
│   ├── arch-packages.txt
│   └── aur-packages.txt
│
├── scripts/
│   ├── lib/
│   │   └── common.sh
│   ├── bootstrap.sh
│   ├── clipboard-menu.sh
│   ├── deploy-configs.sh
│   ├── fonts.sh
│   ├── install.sh
│   ├── power-menu.sh
│   ├── repo-validate.sh
│   ├── services.sh
│   ├── themes.sh
│   └── validate.sh
│
├── .gitignore
└── README.md
```

---

## Managed Configuration

Configuration is organized by application under `configs/`.

Current managed configuration includes:

| Area | Managed configuration |
|---|---|
| Shell | Bash aliases, environment, functions, prompt, FZF, and Zoxide |
| Version control | Git |
| Monitoring | Btop |
| Terminal | Foot |
| Desktop compositor | Hyprland |
| Idle management | Hypridle |
| Screen locking | Hyprlock |
| Wallpaper management | Hyprpaper |
| Notifications | Mako |
| Application launcher | Rofi |
| Status bar | Waybar |

Hyprland configuration is split into focused files for maintainability:

- `appearance.conf`
- `autostart.conf`
- `environment.conf`
- `input.conf`
- `keybinds.conf`
- `monitors.conf`
- `variables.conf`

The main `hyprland.conf` acts as the entry point for the modular configuration.

---

## Requirements

This project is intended for Arch Linux.

Before running the installer, the system should have:

- A regular non-root user
- Working internet access
- `sudo`
- `pacman`
- Access to this repository

The installer performs preflight checks and refuses to run:

- On a non-Arch operating system
- As the root user
- Without `sudo`
- Without `pacman`

---

## Quick Start

Clone the repository:

```bash
git clone git@github.com:coady-rangel/arch-workstation.git
cd arch-workstation
```

Run the complete bootstrap workflow:

```bash
./scripts/bootstrap.sh
```

Restart the graphical session or reboot when required.

> The bootstrap currently includes placeholder font, theme, and service stages. Review the project status and roadmap before treating the repository as a complete unattended deployment.

---

## Package Management

Package definitions are separated by source:

```text
packages/arch-packages.txt
packages/aur-packages.txt
```

### Official Arch packages

Official packages are installed with:

```bash
sudo pacman -S --needed --noconfirm
```

Blank lines and comments are ignored when the manifest is parsed.

### AUR packages

When AUR packages are present, the installer checks for `paru`.

If `paru` is unavailable, the installer:

1. Installs the required build tools.
2. Creates a temporary build directory.
3. Clones the `paru` PKGBUILD.
4. Builds and installs `paru`.
5. Removes the temporary directory on exit.

AUR packages are then installed with:

```bash
paru -S --needed --noconfirm
```

### Optional system update

Run:

```bash
./scripts/install.sh --update
```

to perform a full system update before installing manifest packages.

Run:

```bash
./scripts/install.sh --help
```

to display installer options.

---

## Configuration Deployment

### Service Configuration

Service behavior is defined in:

```text
config/services/default.conf
```

Each line uses this format:

```text
service-name|required
service-name|optional
```

Required services are always enabled by `scripts/services.sh` and checked by `scripts/validate.sh`.

Optional services are skipped by default. Enable them with:

```bash
./scripts/services.sh --enable-optional
```

Both scripts use the same manifest as the single source of truth, which keeps service deployment and validation consistent.

---

`scripts/deploy-configs.sh` creates symlinks from the repository into `~/.config`.

For example:

```text
configs/hypr    -> ~/.config/hypr
configs/waybar  -> ~/.config/waybar
configs/foot    -> ~/.config/foot
```

### Existing configuration

If a target already points to the correct repository directory, no change is made.

If an existing file or directory conflicts with a managed configuration, it is moved to a timestamped backup:

```text
~/.config/<name>.backup-YYYYMMDD-HHMMSS
```

A new symlink is then created.

This prevents existing configuration from being silently overwritten.

---

## Helper Commands

The installer creates command symlinks under:

```text
~/.local/bin
```

Primary helper commands include:

| Command | Source |
|---|---|
| `workstation-install` | `scripts/install.sh` |
| `workstation-bootstrap` | `scripts/bootstrap.sh` |
| `workstation-deploy` | `scripts/deploy-configs.sh` |
| `workstation-validate` | `scripts/validate.sh` |
| `clipboard-menu` | `scripts/clipboard-menu.sh` |
| `power-menu` | `scripts/power-menu.sh` |

Additional executable scripts in the top level of `scripts/` are also linked by name.

Ensure `~/.local/bin` is present in the user's `PATH`.

---

## Desktop Utilities

### Clipboard menu

`scripts/clipboard-menu.sh` provides a Rofi-based clipboard history selector using:

- `cliphist`
- `rofi`
- `wl-copy`

### Power menu

`scripts/power-menu.sh` provides actions for:

- Lock
- Logout
- Suspend
- Reboot
- Shutdown

The script integrates with `loginctl`, `hyprctl`, and `systemctl`.

A complete dependency audit for these helper scripts is still pending.

---

## Validation

Validation is split into two stages:

- Repository validation
- Workstation validation

Repository validation verifies that the repository itself is internally
consistent before deployment. Workstation validation verifies that a deployed
system matches the repository's expected state.

### Repository Validation

The repository validation script checks:

- Required repository structure
- Required files
- Service manifest syntax
- Dependency manifest syntax
- Script executable permissions

Run validation with:

```bash
./scripts/repo-validate.sh
```

This validation is intended to catch repository issues before deployment and is
also executed automatically by GitHub Actions.

### Workstation Validation

The workstation validation script checks every managed configuration under
`configs/`.

For each managed configuration, it verifies that:

1. The corresponding target under `~/.config` is a symlink.
2. The symlink resolves to the expected repository directory.

Run validation with:

```bash
./scripts/validate.sh
```

or, after helper commands are installed:

```bash
workstation-validate
```

Current workstation validation currently verifies:

- Configuration symlinks
- Required services
- Required dependencies

Future releases will expand validation to installed packages,
Hyprland configuration syntax, fonts, themes, helper commands,
and additional runtime health checks.

---

## Continuous Integration

GitHub Actions validates the repository on every push and pull request.

The current validation pipeline performs:

- Bash syntax validation
- ShellCheck
- Repository validation

Repository validation includes:

- Required repository structure
- Required files
- Service manifest validation
- Dependency manifest validation
- Script executable permission validation

The workflow uses:

```bash
shellcheck -x -P SCRIPTDIR scripts/*.sh
```

`-x` enables external source following, and `-P SCRIPTDIR` allows ShellCheck to resolve the shared library relative to each script.

Before committing script changes, run:

```bash
git diff --check
bash -n scripts/*.sh scripts/lib/*.sh
shellcheck -x -P SCRIPTDIR scripts/*.sh
```

---

## Current Package Scope

The current official package manifest includes packages for:

- Core command-line utilities
- Networking
- Development
- Archive and compression support
- File management
- Hyprland
- Waybar
- Foot
- Neovim
- Firefox
- Discord
- Productivity applications
- Media playback
- Steam

The AUR manifest currently includes:

- Zen Browser
- Obsidian
- OnlyOffice
- Bitwarden
- Jagex Launcher

The package manifests still require a complete audit against every managed configuration and helper-script dependency.

---

## Current Platform

| Component | Value |
|---|---|
| Operating system | Arch Linux |
| Desktop compositor | Hyprland |
| Display protocol | Wayland |
| Terminal | Foot |
| Status bar | Waybar |
| Launcher | Rofi configuration present |
| Notification daemon | Mako configuration present |
| Lock screen | Hyprlock configuration present |
| Idle manager | Hypridle configuration present |
| Wallpaper manager | Hyprpaper configuration present |
| Current test environment | VMware virtual machine |

Configuration presence does not by itself guarantee that every related package or service is currently installed and enabled.

---


## Design Principles

This repository follows several guiding principles.

### Reproducibility

A workstation should be rebuildable from version-controlled definitions rather than memory.

### Idempotency

Running deployment scripts more than once should not create duplicate state or unnecessary changes.

### Safety

Existing configuration should be backed up instead of overwritten silently.

### Modularity

Packages, configuration, helper scripts, validation, and setup stages should remain separate and independently understandable.

### Transparency

Scripts should make their actions visible and fail clearly when requirements are not met.

### Portability

Machine-specific values should be isolated so that shared configuration remains reusable.

---

## Development Workflow

Changes should be made in small, focused steps.

A typical workflow is:

```bash
git status
git diff
```

Edit the relevant files, then verify the changes:

```bash
git diff --check
bash -n scripts/*.sh scripts/lib/*.sh
shellcheck -x -P SCRIPTDIR scripts/*.sh
```

Review the final diff:

```bash
git diff
```

Commit with a focused message:

```bash
git add <files>
git commit -m "Describe the change"
git push
```

After pushing, verify that the GitHub Actions workflow passes.

---

## Current Milestone

**Version 0.2.0**

Deployment Framework Complete

Completed:

- Manifest-driven package installation
- Automatic AUR installation
- Bootstrap orchestration
- Configuration deployment
- Repository validation
- Workstation validation
- Helper command installation
- Standardized Bash scripting framework

---

## Roadmap

### Version 0.1 — Repository foundation

- [x] Create repository structure
- [x] Add package manifests
- [x] Add initial application configuration
- [x] Add installation framework
- [x] Add configuration deployment
- [x] Add bootstrap orchestration
- [x] Add shared shell utilities
- [x] Add repository validation
- [x] Add workstation validation
- [x] Standardize Bash scripting
- [x] Add ShellCheck continuous integration

### Version 0.2 — Dependency completion

- [ ] Audit every managed configuration dependency
- [ ] Audit helper-script dependencies
- [ ] Verify official and AUR package ownership
- [ ] Remove duplicate or unnecessary packages
- [ ] Document optional packages
- [ ] Add missing Wayland desktop utilities

### Version 0.3 — Workstation setup automation

- [ ] Implement font installation
- [ ] Implement theme installation
- [ ] Implement service enablement
- [ ] Add default application configuration
- [ ] Add user-directory preparation
- [ ] Add machine-specific configuration templates

### Version 0.4 — Expanded validation

- [x] Add repository validation
- [ ] Validate required commands
- [ ] Validate installed packages
- [ ] Validate helper-command symlinks
- [ ] Validate enabled services
- [ ] Validate font availability
- [ ] Validate theme assets
- [ ] Validate Hyprland configuration syntax
- [ ] Add summarized health-check output

### Version 0.5 — Deployment testing

- [ ] Test clean Arch VM deployment
- [ ] Test repeated bootstrap runs
- [ ] Test conflict backup behavior
- [ ] Test interrupted deployment recovery
- [ ] Test deployment from a fresh user account
- [ ] Document rollback procedures

### Version 1.0 — Reproducible workstation release

- [ ] Complete all setup stages
- [ ] Complete dependency audit
- [ ] Complete validation coverage
- [ ] Pass clean-VM deployment testing
- [ ] Complete bare-metal deployment
- [ ] Publish stable installation documentation

---

## Known Limitations

The repository is not yet a complete unattended workstation installer.

Current limitations include:

- Font automation is not implemented.
- Theme automation is not implemented.
- Package manifests have not completed a full dependency audit.
- Machine-specific monitor and hardware configuration may require manual adjustment.
- The project has primarily been tested in a VMware environment.
- Bare-metal behavior has not yet been fully validated.
- Rollback automation is not implemented.
- Secret management is outside the current project scope.

Review scripts and configuration before running them on an existing workstation.

---

## Philosophy

A personal workstation is still infrastructure.

It has dependencies, configuration drift, operational state, recovery requirements, and lifecycle changes. Treating it as code makes those concerns visible and manageable.

This project is both a practical workstation build and a learning platform for:

- Linux administration
- Shell scripting
- Configuration management
- Infrastructure automation
- Validation
- Continuous integration
- Documentation
- Operational discipline

---

## License

No license has been selected yet.

Until a license is added, the repository remains under the default protections of copyright law.

---
