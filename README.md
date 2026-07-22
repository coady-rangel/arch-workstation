<!--
=============================================================================
AUTO-GENERATED FILE

This README is built from the markdown files in:
    docs/readme.d/

To update this README:
    ./scripts/build-readme.sh

Do not edit README.md directly.
=============================================================================
-->

# Arch Workstation

> A reproducible Arch Linux workstation built with engineering practices.

---

This repository contains my personal Arch Linux workstation configuration, deployment scripts, documentation, and supporting tooling.

Rather than being a collection of dotfiles, this project is designed as reproducible infrastructure: configuration is version controlled, deployments are automated, validation is built in, and documentation evolves alongside the system.


## Contributing

Contributions, suggestions, and discussions are welcome.

Whether reporting a bug, proposing an improvement, or sharing ideas, please aim to keep changes aligned with the project's goals of reproducibility, maintainability, and simplicity.

---

### Development Guidelines

When making changes:

- Keep commits focused on a single logical change.
- Update documentation when behavior changes.
- Validate changes before committing.
- Favor small, incremental improvements over large rewrites.

---

### Reporting Issues

When reporting an issue, include:

- A description of the problem
- Steps to reproduce it
- Relevant log output or screenshots
- System information when applicable

Clear reports make troubleshooting much easier.

---

### Project Philosophy

This repository is intended to grow through continuous improvement.

Thoughtful suggestions and constructive feedback are always appreciated.


## Overview

Arch Workstation is my personal infrastructure project for building and maintaining a reproducible Arch Linux desktop.

The repository combines operating system configuration, deployment automation, validation tooling, and documentation into a single version-controlled project. Every change is intended to be reproducible, understandable, and maintainable.

This repository serves multiple purposes:

- Build a reliable daily-driver Linux workstation
- Document configuration decisions and architectural reasoning
- Automate deployment and validation where practical
- Develop engineering practices that scale beyond a single machine
- Provide a living knowledge base for future maintenance and learning

The long-term goal is to treat workstation configuration with the same discipline used for infrastructure and software engineering projects.


## License

This project is licensed under the MIT License.

See the [LICENSE](LICENSE) file for the full license text.


## Goals & Philosophy

This project is guided by a few core principles:

### Infrastructure as Code

Configuration should be reproducible, version controlled, and easy to recreate on a new system. Manual configuration should be minimized wherever practical.

### Documentation as a First-Class Citizen

Documentation is developed alongside the configuration itself. Decisions, architecture, and operational knowledge are captured as part of the project rather than left to memory.

### Automation Over Repetition

If a task is performed repeatedly, it should be evaluated for automation. Deployment, validation, and maintenance tasks are automated where doing so improves consistency and reliability.

### Incremental Improvement

The workstation is designed to evolve over time through small, well-tested changes rather than large disruptive rewrites.

### Learn by Building

This repository serves as both a production workstation and a learning platform. New technologies are introduced through practical implementation, documented, and refined over time.

### Maintainability

A working system is important, but an understandable system is even more valuable. Clear organization, consistent conventions, and thoughtful documentation take priority over clever shortcuts.


## Features

### Reproducible Deployment

- Automated workstation bootstrap process
- Idempotent deployment scripts
- Version-controlled configuration
- Simple workstation rebuilds

### Modular Configuration

- Configuration organized by subsystem
- Centralized deployment through symbolic links
- Easy to extend and maintain

### Validation & Diagnostics

- Validation scripts to verify system state
- Diagnostic tooling for troubleshooting
- Consistent deployment verification

### Documentation-Driven Development

- Architecture documentation
- Project planning and roadmaps
- Operational notes and implementation history
- Auto-generated README built from modular source files

### Modern CLI Workflow

- Smart directory navigation with **zoxide**
- Fuzzy finding powered by **fzf**
- Fast text searching with **ripgrep**
- Modern file discovery with **fd**
- Improved terminal utilities where appropriate

### Engineering Workflow

- Standardized project entry points via `make`
- Small, incremental changes
- Documentation maintained alongside implementation
- Repository organized for long-term maintainability


## Quick Start

Get up and running with a fresh Arch Workstation installation in just a few steps.

---

### 1. Clone the Repository

```bash
git clone https://github.com/<username>/arch-workstation.git
cd arch-workstation
```

> Replace `<username>` with your GitHub username once the repository is public.

---

### 2. Bootstrap the Workstation

Install required packages and prepare the system.

```bash
./scripts/bootstrap.sh
```

---

### 3. Deploy Configuration

Create the appropriate symbolic links and deploy the managed configuration files.

```bash
./scripts/deploy-configs.sh
```

---

### 4. Validate the Installation

Verify that the workstation has been configured correctly.

```bash
make validate
```

---

## Common Commands

| Command | Description |
|----------|-------------|
| `make readme` | Generate `README.md` from the modular files in `docs/readme.d/` |
| `make validate` | Verify the workstation configuration |
| `make doctor` | Run diagnostic and health checks |

---

## Project Workflow

The repository is designed around a simple engineering workflow:

1. Clone the repository.
2. Bootstrap the workstation.
3. Deploy configuration.
4. Validate the installation.
5. Begin customizing and iterating.

Configuration, documentation, deployment scripts, and validation tooling are all version controlled so the workstation can be reproduced, maintained, and improved over time.


## Installation

The installation process is designed to separate system preparation, configuration deployment, and validation into clear stages.

---

### Requirements

Before beginning, ensure the target system has:

- Arch Linux installed
- An active internet connection
- A non-root user with `sudo` access
- Git installed
- Access to the repository

The installation scripts are intended for Arch Linux systems and may not work correctly on other distributions.

---

### 1. Clone the Repository

```bash
git clone https://github.com/<username>/arch-workstation.git
cd arch-workstation
```

Replace `<username>` with the appropriate GitHub username or repository location.

---

### 2. Run the Bootstrap Script

The bootstrap script prepares the system and installs the required packages.

```bash
./scripts/bootstrap.sh
```

This stage may include:

- Updating package databases
- Installing required packages
- Installing command-line utilities
- Preparing required directories
- Enabling supporting services

Review the script before running it on a new system.

---

### 3. Deploy Configuration Files

Deploy the repository-managed configuration files:

```bash
./scripts/deploy-configs.sh
```

The deployment process creates symbolic links between the repository and the expected configuration locations in the user's home directory.

Keeping configuration files inside the repository provides:

- Version control
- Consistent deployment
- Easier rollback
- Simplified workstation migration
- A single source of truth

The deployment script should be run again if the repository is moved to a different location.

---

### 4. Validate the Workstation

Run the validation process after deployment:

```bash
make validate
```

Validation checks whether the expected files, links, commands, and configuration components are available.

For additional diagnostic information, run:

```bash
make doctor
```

---

### Re-running the Installation

The deployment and validation commands may be run again after configuration changes:

```bash
./scripts/deploy-configs.sh
make validate
```

Scripts should be designed to avoid unnecessary changes when the system is already in the expected state.

---

### Manual Review

Some workstation components may still require manual review or user-specific configuration, including:

- Credentials and authentication
- Hardware-specific settings
- Display and monitor configuration
- Network configuration
- Private environment variables
- Application-specific preferences

Sensitive values should not be committed to the repository.


## Repository Layout

The repository is organized by responsibility to keep configuration, automation, documentation, and project assets separated.

```text
arch-workstation/
├── configs/           # Managed configuration files
├── docs/              # Project documentation
│   └── readme.d/      # Modular README source files
├── scripts/           # Deployment, validation, and utility scripts
├── Makefile           # Common project commands
├── README.md          # Generated project documentation
└── LICENSE
```

---

### `configs/`

Contains the configuration files managed by this repository.

These files are deployed to the appropriate locations using symbolic links rather than being copied directly, ensuring the repository remains the single source of truth.

---

### `docs/`

Contains project documentation, design notes, and supporting material.

The modular README source files are stored in `docs/readme.d/` and combined into the final `README.md` using the README build script.

---

### `scripts/`

Contains automation used throughout the project, including:

- Workstation bootstrap
- Configuration deployment
- Validation
- Diagnostics
- Utility scripts

Each script is designed to perform a single responsibility while remaining reusable as the project grows.

---

### `Makefile`

Provides a consistent interface for common development tasks.

Current targets include:

- `make readme`
- `make validate`
- `make doctor`

Additional commands can be added as the project expands.

---

### Project Philosophy

The repository favors a modular structure over large monolithic scripts or documentation.

Keeping responsibilities separated makes the project easier to understand, test, maintain, and extend over time.


## Development Workflow

This project follows an incremental engineering workflow focused on reproducibility, maintainability, and documentation.

---

### Typical Workflow

1. Create or modify configuration.
2. Update deployment scripts if necessary.
3. Validate the changes.
4. Update documentation.
5. Regenerate the README.
6. Commit the completed work.

The goal is for every change to leave the repository in a deployable, documented, and understandable state.

---

### Common Commands

Generate project documentation:

```bash
make readme
```

Validate the workstation:

```bash
make validate
```

Run diagnostics:

```bash
make doctor
```

---

### Engineering Principles

Development emphasizes:

- Small, incremental changes
- Clear commit history
- Reproducible deployments
- Automation over manual repetition
- Documentation alongside implementation
- Version-controlled configuration

Large changes should be broken into smaller milestones whenever practical.

---

### Project Organization

Each feature should include the appropriate updates to:

- Configuration
- Deployment scripts
- Validation
- Documentation
- README modules (if applicable)

Treat documentation as part of the implementation rather than a task to complete afterward.

---

### Continuous Improvement

The repository is expected to evolve over time.

As new tooling, workflows, or architectural ideas are introduced, the project should continue to prioritize simplicity, maintainability, and reproducibility over unnecessary complexity.


## Documentation

Documentation is maintained alongside the codebase and is considered a core part of the project.

The goal is for architectural decisions, deployment procedures, and operational knowledge to remain version controlled and discoverable.

---

### Documentation Structure

Project documentation is stored in the `docs/` directory.

The project README is generated from modular Markdown files located in:

```text
docs/readme.d/
```

Each module documents a single topic, making updates simpler and reducing merge conflicts.

---

### README Generation

The repository uses an automated README build process.

Generate the README at any time by running:

```bash
make readme
```

The generated `README.md` should not be edited directly.

Instead, update the appropriate file within `docs/readme.d/` and regenerate the README.

---

### Documentation Philosophy

Documentation should answer three questions:

- **What** does this component do?
- **Why** does it exist?
- **How** is it maintained?

Recording the reasoning behind design decisions is often more valuable than documenting the implementation alone.

---

### Keeping Documentation Current

Whenever a feature is added or modified, review whether the following should also be updated:

- Deployment scripts
- Validation scripts
- Project documentation
- README modules
- Architecture notes
- Roadmap

Documentation should evolve alongside the project rather than becoming outdated over time.

---

### Future Improvements

Potential future enhancements include:

- Automatic table of contents generation
- Repository tree generation
- Script inventory generation
- Makefile target documentation
- Project statistics
- Continuous Integration (CI) documentation checks

The documentation system is intentionally designed to grow with the project while remaining simple to maintain.


## Roadmap

This project is developed incrementally. Features are added as the workstation evolves, with an emphasis on maintainability, reproducibility, and automation.

---

### Current Goals

- [x] Repository structure
- [x] Configuration deployment
- [x] Modular documentation
- [x] Automated README generation
- [x] Validation framework
- [x] Makefile entry points

---

### Planned Improvements

#### Installation & Deployment

- [ ] One-command workstation installation
- [ ] Improved bootstrap automation
- [ ] Optional package profiles
- [ ] Automated post-install configuration

#### Configuration Management

- [ ] Additional managed application configurations
- [ ] Environment-specific configuration support
- [ ] Secrets management strategy
- [ ] Configuration version tracking

#### Documentation

- [ ] Automatic table of contents generation
- [ ] Automatic repository tree generation
- [ ] Script documentation generation
- [ ] Makefile target documentation
- [ ] Architecture diagrams

#### Validation & Diagnostics

- [ ] Expanded validation checks
- [ ] Configuration consistency verification
- [ ] Broken symlink detection
- [ ] Package verification
- [ ] System health reporting

#### Developer Experience

- [ ] GitHub Actions for validation
- [ ] Automated documentation checks
- [ ] Release workflow
- [ ] Shell completion improvements

---

### Long-Term Vision

The long-term goal is to create a fully reproducible Arch Linux workstation that can be deployed, maintained, and documented using the same engineering practices applied to modern infrastructure projects.

The repository should remain approachable for new users while providing enough structure to support long-term growth and continuous improvement.


