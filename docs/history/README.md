# Project History

This directory documents how the Arch Workstation repository has evolved, how releases are classified, and how historical milestones are recorded.

---

## Documents

### `RELEASE_HISTORY.md`

Provides a chronological summary of the project's tagged releases and the purpose of each milestone.

### `REPOSITORY_EVOLUTION.md`

Describes how the repository evolved from a collection of workstation configuration files into a documented and reproducible infrastructure platform.

### `VERSIONING.md`

Defines the project's release and versioning framework, including the criteria for patch, minor, and major releases.

---

## Relationship to Other Documentation

The documentation areas in this repository serve different purposes:

- `docs/roadmap/ROADMAP.md` describes planned future work.
- `docs/roadmap/CHANGELOG.md` summarizes completed releases.
- `docs/roadmap/release_notes/` contains detailed notes for individual releases.
- `docs/history/` explains the project's historical development and release framework.

---

## Maintenance

When publishing a release:

1. Confirm the release version using `VERSIONING.md`.
2. Update the roadmap where appropriate.
3. Add or update the release entry in the changelog.
4. Create detailed release notes.
5. Create the Git tag.
6. Publish the corresponding GitHub Release.
7. Update historical documentation when the release represents a meaningful change in the project's direction or architecture.
