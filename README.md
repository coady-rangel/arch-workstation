# Arch Linux Workstation Infrastructure

A reproducible, Infrastructure-as-Code platform for building, deploying, and maintaining a modern Arch Linux workstation.

This project applies software engineering and infrastructure engineering principles to a personal Linux desktop by treating workstation configuration as code: version controlled, automated, validated, documented, and continuously improved.

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

**v3.0.0 — Governance Foundation**

### Completed

- Infrastructure deployment framework
- Bootstrap orchestration
- Manifest-driven package management
- Configuration deployment
- Repository validation
- Workstation validation
- Continuous Integration
- Engineering governance
- Historical documentation
- Release management framework
- Versioning policy

### Current Focus

- Desktop completion
- Expanded validation
- Improved first-run experience
- User experience improvements

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
| `docs/history/VERSIONING.md` | Semantic versioning and release policy |
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

The complete deployment process is orchestrated through:

```text
scripts/bootstrap.sh
```

---

# Repository Structure

```text
arch-workstation/

├── config/
├── configs/
├── packages/
├── scripts/
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
└── README.md
```

---

# Features

Current capabilities include:

- Manifest-driven package installation
- Automatic AUR installation
- Bootstrap orchestration
- Configuration deployment
- Automatic configuration backup
- Managed symbolic links
- Repository validation
- Workstation validation
- Helper command installation
- GitHub Actions CI
- ShellCheck integration

---

# Validation

Validation occurs in two stages.

## Repository Validation

Verifies repository integrity before deployment.

```bash
./scripts/repo-validate.sh
```

---

## Workstation Validation

Verifies that a deployed workstation matches the expected repository state.

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

Run the bootstrap process.

```bash
./scripts/bootstrap.sh
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

Current validation includes:

- Bash syntax
- ShellCheck
- Repository validation

Recommended local verification:

```bash
git diff --check
bash -n scripts/*.sh scripts/lib/*.sh
shellcheck -x -P SCRIPTDIR scripts/*.sh
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
