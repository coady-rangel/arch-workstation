# Arch Linux Workstation Infrastructure

A reproducible, Infrastructure-as-Code platform for building, deploying, and maintaining a modern Arch Linux workstation.

This project applies software engineering and infrastructure engineering principles to a personal Linux desktop by treating workstation configuration as code: version controlled, automated, validated, documented, and continuously improved.

---

# Why This Project Exists

A workstation is infrastructure.

It has dependencies, configuration drift, operational state, recovery requirements, and lifecycle management just like any production system.

Rather than configuring a desktop manually, this project defines the entire workstation through source-controlled configuration and repeatable deployment workflows.

The long-term goal is to create an engineering-grade workstation platform that is:

- Reproducible
- Maintainable
- Extensible
- Documented
- Validated
- Easy to rebuild

---

# Engineering Philosophy

This repository follows a documented engineering process rather than ad-hoc development.

Every meaningful change should improve one or more of the following:

- Maintainability
- Reproducibility
- Automation
- Validation
- Documentation
- User experience

Project governance is documented in:

```
docs/
├── PROJECT_CONSTITUTION.md
├── foundations/
├── planning/
└── roadmap/
```

Core engineering principles include:

- Invest in systems that reduce the cost of future work.
- Design systems before designing features.
- Prefer clarity over cleverness.
- Validate continuously.
- Document the why—not just the how.
- Build for long-term maintainability.

---

# Project Status

**Current Version**

**v3.0.0 — Governance Foundation**

Completed

- Infrastructure deployment framework
- Package management
- Configuration deployment
- Validation tooling
- Repository validation
- Bootstrap orchestration
- Engineering governance
- Project roadmap
- Engineering principles
- Documentation standards

Current Focus

- Desktop completion
- Validation expansion
- First-run experience
- User experience improvements

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

The complete deployment workflow is orchestrated by:

```
scripts/bootstrap.sh
```

---

# Repository Structure

```text
arch-workstation/

configs/        Application configuration
packages/       Package manifests
scripts/        Deployment automation
config/         Deployment manifests

docs/
├── PROJECT_CONSTITUTION.md
├── foundations/
├── planning/
└── roadmap/
```

---

# Features

Current capabilities include:

- Manifest-driven package installation
- Automatic AUR installation
- Configuration deployment
- Automatic configuration backup
- Managed symbolic links
- Bootstrap orchestration
- Repository validation
- Workstation validation
- Helper command installation
- Continuous integration with ShellCheck

---

# Validation

Validation occurs in two stages.

## Repository Validation

Verifies repository integrity before deployment.

Checks include:

- Repository structure
- Required files
- Manifest syntax
- Script permissions

Run:

```bash
./scripts/repo-validate.sh
```

---

## Workstation Validation

Verifies that a deployed workstation matches the expected repository state.

Current validation includes:

- Configuration symlinks
- Required services
- Required dependencies

Run:

```bash
./scripts/validate.sh
```

or

```bash
workstation-validate
```

Validation coverage will continue expanding throughout future releases.

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
Roadmap
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
Release
```

Every completed milestone should include:

- Implementation
- Testing
- Validation
- Documentation
- README updates
- Lessons learned

---

# Documentation

Additional documentation is organized under the `docs/` directory.

| Document | Purpose |
|----------|---------|
| PROJECT_CONSTITUTION.md | Project mission and governance |
| foundations/ | Engineering philosophy and principles |
| planning/ | Feature proposals and design work |
| roadmap/ | Current roadmap and release planning |

---

# Roadmap

Current milestone:

**v0.3 – Governance Foundation**

Upcoming milestones include:

- Desktop completion
- Expanded validation
- User experience improvements
- First-run automation
- Plugin architecture
- AI-assisted workstation tooling

For the complete roadmap, see:

```
docs/roadmap/ROADMAP.md
```

---

# Design Principles

The workstation is designed around several long-term engineering goals.

- Infrastructure as Code
- Reproducibility
- Idempotency
- Safety
- Automation
- Modularity
- Validation
- Documentation
- Continuous Improvement

---

# Continuous Integration

Every push is automatically validated using GitHub Actions.

Current checks include:

- Bash syntax
- ShellCheck
- Repository validation

Local verification before committing:

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

This project follows documented engineering standards.

Before implementing significant changes:

1. Review the Project Constitution.
2. Review the Roadmap.
3. Keep commits focused.
4. Validate before committing.
5. Update documentation alongside code.

---

# License

No license has been selected yet.

Until a license is added, this repository remains protected under default copyright law.
