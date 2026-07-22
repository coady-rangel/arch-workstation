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
