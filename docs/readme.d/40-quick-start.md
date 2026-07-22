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
