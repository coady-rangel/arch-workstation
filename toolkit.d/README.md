# Arch Workstation Toolkit

The Arch Workstation Toolkit provides a unified entry point for operating, maintaining, and extending the Arch Workstation project.

Rather than executing individual scripts directly, users interact with the toolkit, which discovers and launches modular components.

---

# Goals

The toolkit is designed around several engineering principles:

- Single entry point for repository operations
- Modular architecture
- Self-contained feature modules
- Separation of orchestration and implementation
- Easy extensibility

The toolkit coordinates modules. Modules perform the work.

---

# Directory Structure

```text
toolkit
toolkit.d/
├── README.md
├── lib/
│   └── common.sh
└── modules/
    └── support.sh
```

## Components

### toolkit

The executable launcher.

Responsibilities:

- Display menus
- Discover available modules
- Dispatch execution
- Return to the main menu

The launcher should contain as little feature-specific logic as possible.

---

### toolkit.d/lib

Shared helper functions used by multiple modules.

Examples:

- UI helpers
- Logging
- Colors
- Input validation
- Common utilities

---

### toolkit.d/modules

Each module represents a functional area of the project.

Examples:

- Support
- Deployment
- Packages
- Networking
- Configuration
- Documentation
- Utilities

Each module owns its own menus and implementation.

---

# Module Contract

Every module should expose a consistent interface.

Example:

```bash
MODULE_NAME="Support"
MODULE_DESCRIPTION="Diagnostics and support bundle generation"
MODULE_ORDER=10

module_menu() {
    ...
}
```

Future versions may expand this contract as the toolkit evolves.

---

# Design Principles

## Orchestration, Not Implementation

The toolkit should coordinate modules.

Modules should contain feature-specific logic.

Avoid placing business logic directly inside the launcher.

---

## Self-Discovery

Future toolkit versions will automatically discover modules within:

```text
toolkit.d/modules/
```

Adding a new module should require little more than:

1. Create the module.
2. Implement the module contract.
3. Place it in the modules directory.

No launcher modifications should be necessary.

---

## Separation of Concerns

Launcher:

- Navigation
- Module loading
- User interaction

Modules:

- Menus
- Commands
- Workflows

Libraries:

- Shared functionality

---

# Roadmap

## v4.1.0

- Toolkit launcher
- Support module
- Shared library
- Static menu

## Future

- Dynamic module discovery
- Metadata-driven menus
- Search and fuzzy navigation
- Plugin support
- Configuration management
- Additional operational modules

---

# Philosophy

The toolkit should become the primary interface to the Arch Workstation repository.

Individual scripts remain reusable, but day-to-day interaction should begin with a single command:

```bash
./toolkit
```

This provides a consistent experience while keeping the project modular, maintainable, and easy to extend.
