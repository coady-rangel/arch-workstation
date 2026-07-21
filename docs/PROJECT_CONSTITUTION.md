# Project Constitution

This document defines the engineering principles used to design, build, validate, and maintain this repository.

These principles apply to the current project and serve as the default standard for future projects unless a project explicitly documents an exception.

---

## 1. Automation Over Repetition

Repetitive, predictable work should be automated whenever doing so improves reliability, consistency, or maintainability.

Automation must remain understandable and must not silently rewrite behavior it cannot safely interpret.

---

## 2. Standards Must Be Documented

Repository conventions must be written down rather than relying on memory.

Documentation should explain:

- What the standard requires
- Why the standard exists
- How the standard is validated
- When exceptions are appropriate

---

## 3. Standards Must Be Enforceable

Important standards should be enforced through repository tooling and continuous integration where practical.

A documented standard without validation is guidance.

A documented standard with automated validation is policy.

---

## 4. Every Component Has a Clear Responsibility

Scripts, configuration files, libraries, and documentation should each have a clear and limited purpose.

Shared behavior belongs in reusable libraries rather than being duplicated across multiple scripts.

---

## 5. Preserve Behavior During Refactoring

Refactoring should improve structure, readability, or maintainability without unintentionally changing behavior.

Changes that affect behavior must be deliberate, documented, and tested separately from structural cleanup whenever practical.

---

## 6. Validate Before Integration

Changes must be validated before they are committed and pushed.

Validation may include:

- Whitespace and formatting checks
- Bash syntax validation
- ShellCheck
- Repository validation
- Functional testing
- Review of the final diff

---

## 7. Keep Changes Focused

Each commit should represent one understandable engineering change.

Unrelated cleanup, new features, refactoring, and documentation changes should be separated when doing so improves reviewability.

---

## 8. Documentation Is Part of the Implementation

A feature is not complete when only the code works.

Relevant documentation, usage instructions, repository structure, roadmap status, and operational notes must also be reviewed and updated.

---

## 9. Prefer Safe and Idempotent Operations

Automation should be safe to run repeatedly whenever practical.

Scripts should:

- Detect existing state
- Avoid unnecessary destructive actions
- Provide useful error messages
- Fail clearly when assumptions are not met
- Preserve user data unless explicitly instructed otherwise

---

## 10. Make Execution Easy to Understand

Substantial scripts should separate:

1. Configuration
2. Helper functions
3. Argument parsing
4. Core operations
5. Main execution

The entry point should make the script's execution flow easy to identify.

---

## 11. Build for Future Maintenance

Code should be written for the person who will inspect it months later, not only for the person writing it today.

Names, comments, structure, and documentation should reduce the amount of hidden context required to understand the system.

---

## 12. Use an Engineering Completion Checklist

Meaningful features and milestones should include:

- Implementation
- Testing
- Validation
- Documentation updates
- Roadmap review when applicable
- Focused commits
- Lessons learned when valuable

---

## 13. Exceptions Must Be Intentional

Not every script or project requires identical structure.

Small scripts may use a reduced format when additional structure would add noise rather than clarity.

Exceptions should be deliberate and should preserve the intent of the repository standards.

---

## 14. Continuous Improvement

Repository standards are allowed to evolve.

When a better pattern is discovered:

1. Update the documented standard.
2. Update the supporting tools.
3. Migrate existing code safely.
4. Record meaningful lessons learned.

The goal is not permanent rigidity. The goal is consistent, intentional engineering.
