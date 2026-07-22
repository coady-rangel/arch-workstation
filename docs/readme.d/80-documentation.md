## Documentation

Documentation is maintained alongside the codebase and is considered a core part of the project.

The goal is for architectural decisions, deployment procedures, and operational knowledge to remain version controlled and discoverable.

---

### Documentation Structure

Project documentation is stored in the `docs/` directory.

The project README is generated from modular Markdown files located in:

```text
docs/readme.d/
```

Each module documents a single topic, making updates simpler and reducing merge conflicts.

---

### README Generation

The repository uses an automated README build process.

Generate the README at any time by running:

```bash
make readme
```

The generated `README.md` should not be edited directly.

Instead, update the appropriate file within `docs/readme.d/` and regenerate the README.

---

### Documentation Philosophy

Documentation should answer three questions:

- **What** does this component do?
- **Why** does it exist?
- **How** is it maintained?

Recording the reasoning behind design decisions is often more valuable than documenting the implementation alone.

---

### Keeping Documentation Current

Whenever a feature is added or modified, review whether the following should also be updated:

- Deployment scripts
- Validation scripts
- Project documentation
- README modules
- Architecture notes
- Roadmap

Documentation should evolve alongside the project rather than becoming outdated over time.

---

### Future Improvements

Potential future enhancements include:

- Automatic table of contents generation
- Repository tree generation
- Script inventory generation
- Makefile target documentation
- Project statistics
- Continuous Integration (CI) documentation checks

The documentation system is intentionally designed to grow with the project while remaining simple to maintain.
