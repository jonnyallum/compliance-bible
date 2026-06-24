# Commit Guide

## Standard Loop

Every completed task must be marked, logged, committed and pushed.

```bash
git status
git add .
git commit -m "docs: add health and safety act compliance page"
git push
```

## Commit Message Format

Use concise commit messages:

```bash
docs: add fire safety order page
feat: add compliance evidence schema
fix: correct asbestos dutyholder wording
chore: update todo after completed task
```

## Completion Loop

For every task:

1. Write the completed production content.
2. Check it against `CONTRIBUTING.md`.
3. Mark the task `[x]` in `TODO.md`.
4. Add a dated entry in `CHANGELOG.md`.
5. Commit the completed content and tracker updates.
6. Push immediately.

## No Placeholder Rule

Do not create a file just to reserve the path. Create files only when the content is ready to be used.
