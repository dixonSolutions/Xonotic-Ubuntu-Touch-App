# Patches

Optional unified diffs for engine or QuakeC changes. Commit small patches here so reviewers and Clickable testers can apply them without your full `engine/` tree.

Maintainers generate from nested repos under `engine/`:

```bash
cd engine/darkplaces
git format-patch -1 HEAD -o ../../patches/
```

Testers apply before `clickable build` (see [docs/TESTING.md](../docs/TESTING.md)).
