# Support Collector Contract

**Version:** 1.0  
**Status:** Active

---

# Purpose

This document defines the required behavior for every collector within the Arch Workstation Support Framework.

A collector is responsible for gathering diagnostic information for a single subsystem and storing that information within a support bundle.

Every collector must follow this contract to ensure consistent behavior throughout the framework.

---

# Design Philosophy

Collectors are intentionally simple.

Each collector should:

- Gather evidence
- Store evidence
- Report its own execution status

Collectors should **never** interpret or analyze the information they collect.

Analysis belongs to higher layers of the framework.

---

# Collector Lifecycle

Every collector follows the same execution flow.

```text
Start
    ↓
Create Output Directory
    ↓
Collect Diagnostic Information
    ↓
Write Artifacts
    ↓
Write Status
    ↓
Exit
```

Collectors should complete independently of one another.

---

# Collector Responsibilities

Every collector is responsible for:

- Creating its output directory
- Gathering subsystem-specific diagnostics
- Writing diagnostic artifacts
- Writing a `status.txt`
- Exiting cleanly

Collectors should be deterministic whenever possible.

Running the same collector multiple times should produce comparable results for the same system state.

---

# Collector Scope

Each collector owns exactly one subsystem.

Examples include:

- System
- Hyprland
- Waybar
- Audio
- Networking
- Docker

Collectors should not collect information outside their assigned subsystem unless explicitly required.

---

# Required Directory Layout

Every collector creates a single directory beneath the support bundle.

Example:

```text
support/output/<timestamp>/

system/
hyprland/
waybar/
```

Each collector owns every file inside its directory.

Collectors must never modify another collector's output.

---

# Required Output

Every collector must produce:

```text
status.txt
```

Additional artifacts are collector-specific.

Example:

```text
system/

status.txt
cpu.txt
memory.txt
kernel.txt
```

---

# Status File

Every collector must generate a `status.txt`.

Example:

```text
Status: OK

System information collected successfully.
```

---

## Valid Status Values

The framework currently recognizes:

```text
OK
WARNING
ERROR
```

Definitions:

| Status | Meaning |
|----------|---------|
| OK | Collector completed successfully. |
| WARNING | Collector completed with recoverable issues. |
| ERROR | Collector encountered an unrecoverable problem. |

Future framework versions may expand these values.

---

# Artifact Guidelines

Artifacts should be:

- Plain text
- Human-readable
- One command per file
- Predictably named

Preferred:

```text
cpu.txt
kernel.txt
packages.txt
```

Avoid combining unrelated command output into a single file.

---

# Logging

Collectors should use the shared logging helpers provided by:

```text
support/lib/common.sh
```

Collectors should not implement custom logging frameworks.

---

# Shared Library

The `create_collector_dir` helper creates the collector directory and prints its path.

Collectors should capture that path directly:

```bash
COLLECTOR_DIR="$(create_collector_dir "${OUTPUT_ROOT}" "example")"
```

Common functionality should be reused whenever possible.

Examples include:

- Logging
- Directory creation
- Command execution
- Status writing

Duplicate implementations should be avoided.

---

# Error Handling

Collectors should fail gracefully.

Whenever possible:

- Continue collecting remaining information
- Record failures
- Write an appropriate status
- Exit cleanly

A failure in one collector should not prevent other collectors from executing.

---

# Collector Independence

Collectors must remain independent.

Collectors must not:

- Depend on another collector
- Read another collector's output
- Modify another collector's files
- Assume execution order

This allows collectors to execute sequentially or in parallel in future framework versions.

---

# Analysis

Collectors do not analyze collected information.

Examples of analysis include:

- Detecting configuration problems
- Determining health
- Producing recommendations
- Comparing expected versus actual values

Analysis belongs to the summary layer.

---

# Summary Layer

Collectors produce evidence.

The summary engine consumes that evidence.

```text
Collectors
      ↓
Artifacts
      ↓
Summary Engine
      ↓
Report
```

Keeping these responsibilities separate makes the framework easier to maintain and extend.

---

# Collector Template

Every new collector should follow the same high-level structure:

```text
Initialize
Create Output Directory
Collect Information
Write Artifacts
Write Status
Exit
```

Implementation details may differ, but the overall lifecycle should remain consistent.

---

# Design Principles

The Support Framework follows these engineering principles:

- Single Responsibility
- Separation of Concerns
- Predictable Output
- Human-Readable Artifacts
- Minimal Dependencies
- Modular Architecture
- Graceful Failure Handling
- Extensibility

All collectors should reinforce these principles.

---

# Future Compatibility

This contract is intended to remain stable as the framework evolves.

Future framework versions may introduce:

- Parallel execution
- Metadata files
- JSON output
- Archive generation
- HTML reports
- Plugin registration

Collectors that follow this contract should remain compatible with future enhancements without requiring significant modification.
