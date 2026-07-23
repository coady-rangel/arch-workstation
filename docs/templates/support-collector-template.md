# Support Collector Template

This document provides the recommended structure for implementing new collectors within the Arch Workstation Support Framework.

Use this template when creating a new subsystem collector.

---

# Collector Checklist

Before considering a collector complete, verify that it:

- [ ] Collects information for exactly one subsystem
- [ ] Creates its own output directory
- [ ] Writes one artifact per command
- [ ] Produces a `status.txt`
- [ ] Uses shared library helpers
- [ ] Handles missing commands gracefully
- [ ] Exits cleanly
- [ ] Does not analyze collected data
- [ ] Does not depend on another collector

---

# Recommended Directory

```text
support/
└── collectors/
    └── example.sh
```

---

# Output Structure

Each collector owns a single directory inside the generated support bundle.

Example:

```text
example/

status.txt
config.txt
version.txt
logs.txt
```

Collectors must never write outside their own directory.

---

# Collector Skeleton

```bash
#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="${SCRIPT_DIR}/../lib"

source "${LIB_DIR}/common.sh"

OUTPUT_ROOT="$1"
COLLECTOR_DIR="$(create_collector_dir "${OUTPUT_ROOT}" "example")"

log_info "Running Example collector..."

capture_command \
    "Example Version" \
    "${OUTPUT_DIR}/version.txt" \
    example --version

capture_command \
    "Example Configuration" \
    "${OUTPUT_DIR}/config.txt" \
    cat /etc/example.conf

capture_command \
    "Example Logs" \
    "${OUTPUT_DIR}/logs.txt" \
    journalctl -u example.service

write_status \
    "${OUTPUT_DIR}" \
    "OK" \
    "Example collector completed successfully."
```

---

# Initialization

Every collector should:

- Load the shared library
- Receive the output directory as its first argument
- Create its collector directory
- Begin logging

---

# Collecting Information

Each command should generate its own artifact.

Preferred:

```text
version.txt
config.txt
logs.txt
packages.txt
```

Avoid combining unrelated command output into a single file.

---

# Command Execution

Use the shared helper functions whenever possible.

Example:

```bash
capture_command \
    "Kernel Version" \
    "${OUTPUT_DIR}/kernel.txt" \
    uname -r
```

This keeps collectors consistent and centralizes error handling.

---

# Status Reporting

Every collector must finish by writing a status file.

Example:

```bash
write_status \
    "${OUTPUT_DIR}" \
    "OK" \
    "Collector completed successfully."
```

Possible status values:

- OK
- WARNING
- ERROR

---

# Logging

Collectors should use the shared logging functions.

Examples:

```bash
log_info "Collecting system information..."
```

```bash
log_warn "Command not available."
```

```bash
log_error "Collector failed."
```

Do not implement collector-specific logging frameworks.

---

# Error Handling

Collectors should fail gracefully.

If one command fails:

- Continue collecting remaining information whenever practical.
- Record the failure in the relevant artifact or status.
- Do not terminate the entire support bundle unless absolutely necessary.

---

# Best Practices

✔ Keep collectors focused on a single subsystem.

✔ One command should produce one output file.

✔ Prefer descriptive filenames.

✔ Keep output human-readable.

✔ Reuse shared helper functions.

✔ Keep implementation simple.

---

# Avoid

Avoid:

- Reading another collector's output
- Modifying another collector's files
- Performing health analysis
- Producing recommendations
- Parsing another collector's artifacts
- Adding unnecessary dependencies

Collectors gather evidence.

They do not interpret it.

---

# Typical Collector Flow

```text
Start
    ↓
Load Shared Library
    ↓
Create Output Directory
    ↓
Collect Information
    ↓
Write Artifacts
    ↓
Write Status
    ↓
Exit
```

---

# Future Compatibility

Collectors written using this template should remain compatible with future framework enhancements, including:

- Parallel execution
- Summary engine
- HTML reporting
- JSON metadata
- Archive generation
- Plugin registration

Following this template ensures new collectors integrate cleanly with the Support Framework while remaining simple, predictable, and easy to maintain.
