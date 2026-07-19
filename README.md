# Arch Linux Workstation Infrastructure

A reproducible, Infrastructure-as-Code (IaC) approach to building and maintaining my personal Arch Linux workstation.

This repository contains the configuration files, package manifests, and automation scripts required to deploy and maintain a consistent Hyprland-based desktop environment.

---

# Overview

The goal of this project is to eliminate manual workstation configuration by treating a Linux desktop like production infrastructure:

- Version controlled
- Documented
- Automated
- Reproducible
- Easy to rebuild

Instead of configuring a workstation by hand, the entire environment can be recreated from source control.

---

# Architecture

```text
                GitHub
                   │
                   ▼
        Arch Linux Base Install
                   │
                   ▼
         Package Installation
                   │
                   ▼
        Configuration Deployment
                   │
                   ▼
        Hyprland Desktop Environment
                   │
                   ▼
        Reproducible Workstation
```

---

# Repository Structure

```text
dotfiles/

├── configs/
│   ├── foot/
│   ├── hypr/
│   ├── hypridle/
│   ├── hyprlock/
│   ├── hyprpaper/
│   ├── mako/
│   ├── rofi/
│   └── waybar/
│
├── packages/
│   └── arch-packages.txt
│
├── scripts/
│   ├── bootstrap.sh
│   ├── clipboard-menu.sh
│   └── install.sh
│
└── README.md
```

---

# Current Features

## Desktop

- Hyprland Wayland compositor
- Waybar status bar
- Foot terminal
- Rofi application launcher
- Mako notifications

## System

- PipeWire audio
- WirePlumber session management
- Polkit integration
- Thunar file manager
- GVFS support

## Utilities

- Screenshot tools (Grim + Slurp)
- Clipboard history (Cliphist)
- Package manifest
- Modular Hyprland configuration
- Deployment scripts

---

# Quick Start

Clone the repository:

```bash
git clone https://github.com/<your-username>/dotfiles.git
cd dotfiles
```

Install packages:

```bash
./scripts/install.sh
```

Deploy configuration:

```bash
./scripts/bootstrap.sh
```

Restart your session or reboot to apply all changes.

---

# Design Principles

This repository follows several infrastructure engineering principles.

## Infrastructure as Code

Configuration is stored in Git instead of being manually recreated.

## Modular Design

Each application maintains its own configuration directory.

## Reproducibility

A clean Arch Linux installation should be able to reproduce this workstation using only the contents of this repository.

## Documentation

Configuration decisions are documented rather than relying on memory.

## Automation First

Manual setup should eventually be replaced by repeatable scripts.

---

# Current Platform

| Component | Value |
|-----------|-------|
| Operating System | Arch Linux |
| Desktop | Hyprland |
| Display Server | Wayland |
| Terminal | Foot |
| Status Bar | Waybar |
| Launcher | Rofi |
| Notification Daemon | Mako |
| Development Environment | VMware Virtual Machine |

---

# Roadmap

Future improvements include:

- Hyprlock integration
- Hypridle configuration
- Wallpaper management
- Theme customization
- Automated package installation
- Bare-metal deployment
- Additional development tooling
- CI validation for configuration files

---

# Philosophy

A workstation should be treated like any other piece of infrastructure.

Rather than manually configuring a desktop every time hardware changes or an operating system is reinstalled, the entire environment should be reproducible from version-controlled configuration.

The objective is not simply to customize Linux—it is to build a maintainable, documented, and repeatable workstation deployment process.

---

# License

This repository is intended for personal use and educational purposes. Feel free to reference or adapt portions of the configuration for your own projects.
