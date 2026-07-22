# Arch Linux Workstation Infrastructure

An engineering-first Infrastructure-as-Code platform for building, deploying, and maintaining a modern Arch Linux workstation.

This project applies professional software and infrastructure engineering practices to a personal Linux desktop by treating workstation configuration as code: version controlled, automated, validated, documented, and continuously improved.

The goal is to build a workstation that is reproducible, maintainable, and deployable using the same engineering discipline applied to production infrastructure.

---

# Why This Project Exists

A workstation is infrastructure.

Like production infrastructure, it has dependencies, configuration drift, operational state, recovery requirements, and lifecycle management.

Rather than configuring a desktop manually, this repository defines an entire workstation through source-controlled configuration and repeatable deployment workflows.

The long-term goal is to build an engineering-grade workstation platform that is:

- Reproducible
- Maintainable
- Extensible
- Automated
- Validated
- Fully Documented
- Easy to Rebuild

---

# Engineering Philosophy

This repository follows a documented engineering process rather than ad-hoc development.

Every meaningful change should improve one or more of the following:

- Maintainability
- Reproducibility
- Automation
- Validation
- Documentation
- User Experience

Core engineering philosophy is documented in:

- `docs/PROJECT_CONSTITUTION.md`
- `docs/foundations/PRINCIPLES.md`
- `docs/foundations/ENGINEERING_MAXIMS.md`

The project emphasizes:

- Design systems before features.
- Prefer clarity over cleverness.
- Automate repetitive work.
- Validate continuously.
- Document the *why* as well as the *how*.
- Build for long-term maintainability.

---

# Project Status

## Current Release

**v3.1.x — Repository Engineering**

### Completed

- Infrastructure deployment framework
- Bootstrap orchestration
- Manifest-driven package management
- Configuration deployment
- Modular repository validation framework
- Repository doctor framework
- Shared script libraries
- Repository configuration library
- GitHub Actions Continuous Integration
- ShellCheck integration
- Engineering governance
- Historical documentation
- Release management framework
- Semantic Versioning

### Current Focus

- Desktop completion
- Workstation validation improvements
- User experience improvements
- Expanded automation

---

# Documentation

Project documentation is organized by purpose.

## Engineering Governance

| Document | Purpose |
|----------|---------|
| `docs/PROJECT_CONSTITUTION.md` | Project mission, governance, and engineering standards |
| `docs/foundations/PRINCIPLES.md` | Core engineering principles |
| `docs/foundations/ENGINEERING_MAXIMS.md` | Practical engineering guidelines |
| `docs/history/decisions/` | Architecture and engineering decisions |

---

## Planning

| Document | Purpose |
|----------|---------|
| `docs/roadmap/ROADMAP.md` | Future roadmap and project milestones |
| `docs/planning/PROPOSED_FEATURES.md` | Proposed enhancements and future ideas |

---

## Release Management

| Document | Purpose |
|----------|---------|
| `docs/roadmap/CHANGELOG.md` | Chronological release history |
| `docs/roadmap/release_notes/` | Detailed release notes for each version |
| `docs/history/VERSIONING.md` | Semantic Versioning and release policy |
| `docs/templates/RELEASE_NOTE_TEMPLATE.md` | Standard template for future releases |

---

## Project History

| Document | Purpose |
|----------|---------|
| `docs/history/README.md` | Overview of historical documentation |
| `docs/history/RELEASE_HISTORY.md` | High-level release history |
| `docs/history/REPOSITORY_EVOLUTION.md` | Evolution of the repository over time |

---

# Architecture

```text
                Git Repository
                       │
                       ▼
             Bootstrap Orchestration
                       │
         ┌─────────────┴─────────────┐
         ▼                           ▼
 Package Installation      Configuration Deployment
         ▼                           ▼
    System Setup             Managed Symlinks
         ▼                           ▼
         └─────────────┬─────────────┘
                       ▼
             Validation Framework
                       ▼
          Reproducible Workstation
```

The workstation deployment process is orchestrated through:

```text
scripts/bootstrap.sh
```

Repository engineering and validation are provided through:

```text
scripts/doctor.sh
```

---

# Repository Components

| Component | Purpose |
|-----------|---------|
| `scripts/bootstrap.sh` | Deploys and configures the workstation |
| `scripts/doctor.sh` | Coordinates repository validation and health checks |
| `scripts/doctor.d/` | Modular repository validation checks |
| `scripts/lib/` | Shared libraries used by repository tooling |

---

# Repository Structure

```text
arch-workstation/
│
├── config/                  # User configuration templates
├── configs/                 # Managed configuration files
├── packages/                # Package manifests
│
├── scripts/
│   ├── bootstrap.sh         # Primary deployment entry point
│   ├── validate.sh          # Workstation validation
│   ├── doctor.sh            # Repository health checks
│   ├── doctor.d/            # Modular repository validation
│   │   ├── documentation.sh
│   │   ├── environment.sh
│   │   ├── repository.sh
│   │   └── validation.sh
│   │
│   └── lib/                 # Shared shell libraries
│       ├── common.sh
│       ├── doctor-common.sh
│       └── repo-config.sh
│
├── docs/
│   ├── foundations/
│   ├── history/
│   │   ├── decisions/
│   │   ├── README.md
│   │   ├── RELEASE_HISTORY.md
│   │   ├── REPOSITORY_EVOLUTION.md
│   │   └── VERSIONING.md
│   │
│   ├── planning/
│   ├── roadmap/
│   │   ├── CHANGELOG.md
│   │   ├── ROADMAP.md
│   │   └── release_notes/
│   │
│   ├── templates/
│   └── PROJECT_CONSTITUTION.md
│
├── .github/                 # CI workflows
├── .editorconfig            # Repository formatting standards
│
└── README.md
```

---

# Features

## Deployment

- Manifest-driven package installation
- Automatic AUR installation
- Bootstrap orchestration
- Configuration deployment
- Managed symbolic links
- Automatic configuration backup

## Engineering

- Modular repository validation framework
- Repository doctor
- Automatic Bash syntax validation
- ShellCheck integration
- GitHub Actions Continuous Integration
- Documentation-first workflow
- Engineering governance

---
# Validation

Repository validation is performed using the modular doctor framework.

Run:

```bash
./scripts/doctor.sh
```

The doctor performs:

- Documentation checks
- Environment validation
- Repository integrity checks
- Bash syntax validation
- ShellCheck analysis
- Automatic repository script discovery

Workstation validation verifies that a deployed workstation matches the expected repository state.

```bash
./scripts/validate.sh
```

or

```bash
workstation-validate
```

---

# Quick Start

Clone the repository.

```bash
git clone git@github.com:coady-rangel/arch-workstation.git

cd arch-workstation
```

Deploy the workstation.

```bash
./scripts/bootstrap.sh
```

Validate the repository.

```bash
./scripts/doctor.sh
```

Restart the graphical session when deployment completes.

---

# Engineering Workflow

Development follows a documented engineering lifecycle.

```text
Idea
 │
 ▼
Proposal
 │
 ▼
Planning
 │
 ▼
Implementation
 │
 ▼
Validation
 │
 ▼
Documentation
 │
 ▼
Release Notes
 │
 ▼
Git Tag
 │
 ▼
GitHub Release
```

Every completed milestone should include:

- Implementation
- Testing
- Validation
- Documentation
- README updates
- Lessons learned

---

# Design Principles

The workstation is built around long-term engineering goals:

- Infrastructure as Code
- Reproducibility
- Idempotency
- Automation
- Safety
- Modularity
- Validation
- Documentation
- Continuous Improvement

---

# Continuous Integration

Every push is automatically validated using GitHub Actions.

Current automated validation includes:

- Bash syntax
- ShellCheck
- Repository validation

Recommended local verification:

```bash
git diff --check
./scripts/doctor.sh
```

---

# Current Platform

| Component | Value |
|-----------|-------|
| Operating System | Arch Linux |
| Display Protocol | Wayland |
| Desktop | Hyprland |
| Terminal | Foot |
| Status Bar | Waybar |
| Notifications | Mako |
| Lock Screen | Hyprlock |
| Wallpaper | Hyprpaper |

---

# Contributing

Before implementing significant changes:

1. Review the Project Constitution.
2. Review the Engineering Principles.
3. Review the Roadmap.
4. Follow the documented versioning framework.
5. Keep commits focused.
6. Validate before committing.
7. Update documentation alongside code.
8. Publish release notes for official releases.

---

# License

No license has been selected yet.

Until a license is added, this repository remains protected under default copyright law.
