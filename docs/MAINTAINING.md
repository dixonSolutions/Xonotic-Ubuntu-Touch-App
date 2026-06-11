# Maintainer guide (no local compile)

This project is designed so **you edit source and others build**. That saves disk, CPU, and time on your machine.

## Daily workflow

1. `./scripts/fetch-sources.sh code` — clones source into `engine/` (large, but no compile).
2. Edit files under `engine/` (see [SOURCES.md](SOURCES.md)).
3. Commit and share your work (see below).
4. Ask a Clickable tester to run `clickable build --arch arm64` on your branch.

Do **not** run `scripts/build-engine.sh`, `scripts/compile-for-click.sh`, or `cd engine && ./all compile` unless you explicitly want a local build.

## Sharing changes

`engine/` is not committed to this port repo (too large, separate upstream histories). Use one of:

| Method | When |
|--------|------|
| **Fork + push** | Fork [darkplaces](https://gitlab.com/xonotic/darkplaces) and [xonotic-data.pk3dir](https://gitlab.com/xonotic/xonotic-data.pk3dir); push from nested repos under `engine/`; tell testers your fork URLs |
| **`patches/`** | Export `git format-patch` / unified diffs into `patches/` and commit those to this repo (small, reviewable) |
| **Branch on this repo** | Port-specific files only: `touch/`, `packaging/`, `scripts/`, docs |

Point fetch scripts at your forks with environment variables:

```bash
DARKPLACES_URL=https://gitlab.com/you/darkplaces.git ./scripts/fetch-sources.sh code
DATA_URL=https://gitlab.com/you/xonotic-data.pk3dir.git ./scripts/fetch-sources.sh code
```

## Disk usage

| Fetch | Approx. role |
|-------|----------------|
| `minimal` | Engine C only (~100 MB darkplaces) |
| `code` | UI + QuakeC + compile deps (~large; `xonotic-data.pk3dir` includes assets) |
| `full` | Entire game + maps/music (very large) |

After an accidental compile: `./scripts/clean-local-artifacts.sh`

## Screen / landscape layout

Edit **`touch/screen-calc.sh`** for detection and landscape sizing. No compile:

```bash
./scripts/test-screen-calc.sh
XONOTIC_SCREEN_WIDTH=1224 XONOTIC_SCREEN_HEIGHT=2700 ./scripts/test-screen-calc.sh
```

See [SCREEN.md](SCREEN.md). QuakeC HUD should use `vid_width` / `vid_height` cvars, not hardcoded pixels.

## What testers need

- **Compile + UI changes**: `code` fetch (default in `clickable.json` prebuild).
- **Play in-game on device**: `full` fetch before build, or ship map pk3s separately.
