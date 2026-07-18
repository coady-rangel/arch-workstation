# Arch Linux Workstation Infrastructure

## Overview

This repository contains the configuration, automation, and documentation required to reproduce my Arch Linux workstation environment.

The goal is to transform a manual Linux installation into a documented, version-controlled, and repeatable workstation deployment process.

---

## Architecture

```text
Hardware
    |
    v
Arch Linux
    |
    v
System Configuration
    |
    v
Dotfiles
    |
    v
Automation Scripts
    |
    v
Reproducible Workstation
```

---

## Repository Structure

```text
dotfiles/

├── configs/
│   ├── hypr/
│   ├── waybar/
│   ├── kitty/
│   └── nvim/
│
├── packages/
│   └── arch-packages.txt
│
├── scripts/
│   ├── install.sh
│   └── bootstrap.sh
│
└── docs/
```

---

## Goals

* Create a reproducible Arch Linux environment
* Manage workstation configuration through Git
* Automate package installation
* Version control desktop environment configuration
* Document system architecture and deployment decisions
* Enable future migration from VM to bare-metal hardware

---

## Current Platform

Operating System:
Arch Linux

Environment:
VMware Virtual Machine

Architecture:
x86_64

Purpose:
Development workstation and future Linux desktop environment

---

## Future Target

The long-term goal is to deploy this configuration onto bare-metal hardware using the same principles used in infrastructure engineering:

```text
Plan
  |
Deploy
  |
Validate
  |
Document
  |
Automate
```

---

## Components

Planned workstation stack:

* Hyprland Wayland compositor
* Waybar status bar
* Kitty terminal emulator
* Neovim development environment
* Shell customization
* System automation scripts
* Package management
* Configuration management

---

## Philosophy

This repository treats a personal workstation as infrastructure.

The objective is not only to configure a machine, but to create a documented and repeatable deployment process that can rebuild the environment from a clean Arch Linux installation.
