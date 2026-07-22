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
