# Arch Workstation Support Framework

A modular diagnostic framework for collecting reproducible support bundles from an Arch Linux workstation.

---

## Overview

The Support Framework gathers diagnostic information from individual subsystems and stores the results in a structured support bundle.

Each subsystem is handled by an independent **collector** responsible for gathering evidence only.

The framework intentionally separates:

- Collection
- Storage
- Analysis
- Reporting

This separation keeps the framework modular, predictable, and easy to extend.

---

## Goals

- Modular architecture
- Reproducible support bundles
- Human-readable artifacts
- Minimal dependencies
- Easy extensibility
- Predictable output
- Graceful failure handling

---

## Directory Structure

```text
support/
├── collectors/
├── lib/
├── output/
├── templates/
├── README.md
└── support.sh
```

### collectors/

Contains one collector per subsystem.

Examples:

- system
- hyprland
- waybar

Each collector gathers evidence for a single subsystem.

---

### lib/

Shared helper functions used by collectors.

Examples include:

- Logging
- Command execution
- Status reporting
- Directory creation

Collectors should reuse these helpers whenever possible.

---

### output/

Generated support bundles.

Example:

```text
output/
├── latest -> 2026-07-23_04-01-22/
└── 2026-07-23_04-01-22/
```

Each bundle is timestamped and self-contained.

---

### templates/

Reusable templates for future collectors and support framework components.

---

## Running the Framework

From the repository root:

```bash
./support/support.sh
```

A new timestamped support bundle will be created under:

```text
support/output/
```

The `latest` symbolic link is automatically updated to point to the newest bundle.

---

## Bundle Layout

A typical bundle looks like:

```text
2026-07-23_04-01-22/
├── system/
│   ├── status.txt
│   ├── cpu.txt
│   ├── memory.txt
│   └── ...
├── hyprland/
│   ├── status.txt
│   ├── version.txt
│   └── ...
└── ...
```

Each collector owns its own directory.

Collectors never modify another collector's output.

---

## Collector Responsibilities

Every collector is responsible for:

- Creating its output directory
- Gathering diagnostic information
- Producing diagnostic artifacts
- Writing a `status.txt` file
- Exiting cleanly

Collectors do **not**:

- Analyze results
- Generate summaries
- Modify another collector
- Depend on another collector

---

## Status Reporting

Every collector produces a `status.txt` file.

Possible values include:

```text
Status: OK
```

```text
Status: WARNING
```

```text
Status: ERROR
```

Additional context should be provided whenever appropriate.

---

## Framework Philosophy

The framework follows a simple pipeline:

```text
Commands
    ↓
Collectors
    ↓
Artifacts
    ↓
Summary
    ↓
Report
```

Collectors gather evidence.

A future summary engine will consume those artifacts and produce human-readable diagnostics.

This separation keeps collectors simple while making the reporting layer more powerful.

---

## Adding a New Collector

Adding support for a new subsystem should only require:

1. Create a new collector under `support/collectors/`
2. Collect subsystem-specific diagnostics
3. Write a `status.txt`
4. Exit cleanly

No framework changes should be required.

---

## Current Collectors

Current collectors include:

- System
- Hyprland

Additional collectors planned:

- Waybar
- Networking
- Audio
- Docker
- NVIDIA
- Systemd
- Storage

---

## Future Enhancements

Planned improvements include:

- Summary engine
- Archive generation
- HTML reports
- JSON metadata
- Collector templates
- Parallel collector execution
- Automated validation

---

## License

This framework is part of the Arch Workstation project and follows the same licensing and contribution guidelines as the rest of the repository.
