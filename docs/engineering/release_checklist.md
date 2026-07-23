cat > docs/engineering/release_checklist.md <<'EOF'
# Release Checklist

---

## Preparation

- [ ] Confirm the intended release version.
- [ ] Confirm the release branch is up to date.
- [ ] Confirm the working tree is clean.
- [ ] Create or update the release notes:
  `docs/roadmap/release_notes/vX.Y.Z.md`

---

## Validation

- [ ] Run repository health checks:

  ```bash
  make doctor
