# Release and Versioning Framework

The Arch Workstation project follows **Semantic Versioning (SemVer)** as a decision-making framework for managing releases.

Version numbers follow the format:

```text
MAJOR.MINOR.PATCH
```

Example:

```text
3.2.1
```

Where:

- **MAJOR** – Significant architectural or operational milestone.
- **MINOR** – New capabilities that expand the existing platform.
- **PATCH** – Fixes, maintenance, and refinements.

---

# Release Philosophy

A release represents a meaningful, validated, and documented project milestone.

Not every commit deserves a release.

An official release should represent a stable checkpoint in the evolution of the workstation.

Every release should normally include:

- Completed implementation
- Successful validation/testing
- Updated documentation
- Updated CHANGELOG
- Release notes
- Git tag
- GitHub Release

---

# Patch Releases (X.Y.Z)

Example:

```text
1.1.0 → 1.1.1
```

Patch releases are used for maintenance work that does not significantly expand the platform.

Typical examples include:

- Bug fixes
- Script corrections
- Reliability improvements
- Cleanup
- Removal of obsolete components
- Documentation corrections related to the existing release
- Small quality-of-life improvements

Patch releases should remain fully compatible with the current major and minor release.

---

# Minor Releases (X.Y.0)

Example:

```text
1.1.1 → 1.2.0
```

Minor releases introduce meaningful new functionality while preserving the existing platform architecture.

Examples include:

- New workstation capabilities
- Additional deployment automation
- New installer functionality
- New desktop workflows
- New supported applications
- Significant quality-of-life improvements
- Expanded validation capabilities

Minor releases build upon the current platform without redefining it.

---

# Major Releases (X.0.0)

Example:

```text
2.4.3 → 3.0.0
```

Major releases represent significant engineering milestones that advance the platform to a new stage of maturity.

Examples include:

- New deployment architecture
- Repository restructuring
- Breaking workflow changes
- Infrastructure redesign
- Governance milestones
- Major roadmap milestone completion
- Significant changes to how the workstation is deployed or maintained

A major release should represent a clear evolution of the platform rather than simply a large collection of changes.

---

# Changes That Usually Do Not Require a Release

The following changes normally do not justify creating a new version:

- Typographical corrections
- Formatting changes
- Comment updates
- Work-in-progress commits
- Experimental changes
- Internal refactoring with no user-visible impact
- Routine documentation edits

These changes should simply be committed as part of normal development until they become part of a future release.

---

# Selecting the Correct Version

Before creating a release, ask the following questions:

1. Does this fundamentally change how the platform is designed or operated?
   - **Yes:** Major release.

2. Does this add meaningful functionality without changing the architecture?
   - **Yes:** Minor release.

3. Does this improve, stabilize, or fix existing functionality?
   - **Yes:** Patch release.

4. Is this only editorial or administrative work?
   - **Yes:** No release is necessary.

---

# Required Release Artifacts

Every official release should include:

- Git tag
- GitHub Release
- CHANGELOG entry
- Release notes
- Clean repository state
- Successful validation/testing

The version number should remain consistent across every release artifact.

---

# Standard Release Workflow

1. Complete planned work.
2. Validate the repository.
3. Ensure the working tree is clean.
4. Select the appropriate version.
5. Update the roadmap if necessary.
6. Update `docs/roadmap/CHANGELOG.md`.
7. Create or update release notes.
8. Review documentation for accuracy.
9. Commit release documentation.
10. Create an annotated Git tag.
11. Push the commit and tag.
12. Publish the GitHub Release.
13. Verify the published release.

---

# Git Tag Standard

Official releases should use annotated tags.

Create the tag:

```bash
git tag -a vX.Y.Z -m "Release vX.Y.Z"
```

Push the tag:

```bash
git push origin vX.Y.Z
```

Release tags should remain immutable after publication except to correct serious release-management errors.

---

# Long-Term Philosophy

The purpose of versioning is not simply to count releases—it is to communicate the significance of change.

Version numbers should help contributors understand the maturity, scope, and impact of each release while providing a clear historical record of the project's evolution.
