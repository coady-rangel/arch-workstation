from pathlib import Path
import shutil
import re

readme = Path("README.md")

if not readme.exists():
    raise SystemExit("README.md not found.")

# Backup
backup = readme.with_suffix(".md.bak")
shutil.copy2(readme, backup)

text = readme.read_text()

#
# 1. Project Status
#
old = """The following areas are still in progress:

- Service automation
- Font setup automation
- Theme setup automation
- Complete dependency auditing
- Expanded workstation health validation
- Clean-VM deployment testing
- Idempotency and recovery testing
- Bare-metal deployment"""

new = """The following areas are still in progress:

- Complete dependency auditing
- Expanded workstation health validation
- Clean-VM deployment testing
- Idempotency and recovery testing
- Bare-metal deployment"""

text = text.replace(old, new)

#
# 2. Workstation validation description
#
old = """Current workstation validation is intentionally limited to configuration
deployment. Package, command, service, font, theme, and runtime checks are
planned."""

new = """Current workstation validation currently verifies:

- Configuration symlinks
- Required services
- Required dependencies

Future releases will expand validation to installed packages,
Hyprland configuration syntax, fonts, themes, helper commands,
and additional runtime health checks."""

text = text.replace(old, new)

#
# 3. Version 0.1 roadmap
#
pattern = re.compile(
    r"### Version 0\.1 — Repository foundation.*?### Version 0\.2",
    re.S,
)

replacement = """### Version 0.1 — Repository foundation

- [x] Create repository structure
- [x] Add package manifests
- [x] Add initial application configuration
- [x] Add installation framework
- [x] Add configuration deployment
- [x] Add bootstrap orchestration
- [x] Add shared shell utilities
- [x] Add repository validation
- [x] Add workstation validation
- [x] Standardize Bash scripting
- [x] Add ShellCheck continuous integration

### Version 0.2"""

text = pattern.sub(replacement, text)

#
# 4. Insert milestone section
#
marker = "## Roadmap"

if "## Current Milestone" not in text:
    milestone = """## Current Milestone

**Version 0.2.0**

Deployment Framework Complete

Completed:

- Manifest-driven package installation
- Automatic AUR installation
- Bootstrap orchestration
- Configuration deployment
- Repository validation
- Workstation validation
- Helper command installation
- Standardized Bash scripting framework

---

"""
    text = text.replace(marker, milestone + marker)

#
# 5. Remove outdated limitations
#
text = text.replace("- Service automation is not implemented.\n", "")
text = text.replace("- Validation currently focuses on configuration symlinks.\n", "")

readme.write_text(text)

print("README updated successfully.")
print(f"Backup written to {backup}")
