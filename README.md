# Xonotic for Ubuntu Touch

Source-first port: no Qt/QML shell, no binaries in git, **no local compile required for maintainers**. Edit upstream source under `engine/`, push your forks or `patches/`, and let Clickable community testers build the click package.

## Maintainer workflow (you)

```bash
# Fetch source only — does not compile
./scripts/fetch-sources.sh code

# Edit game UI, controls, engine (see docs/SOURCES.md)
# engine/darkplaces/                          — C engine
# engine/data/xonotic-data.pk3dir/qcsrc/      — menus, HUD, QuakeC

# Share changes: push from nested git repos under engine/, or add patches/ diffs
# Do NOT run compile scripts locally unless you choose to

# Test landscape screen math without compiling:
./scripts/test-screen-calc.sh
```

| Path | Purpose |
|------|---------|
| `engine/` | Fetched Xonotic trees (gitignored; clone locally) |
| `touch/xonotic.cfg` | Gameplay / graphics defaults (tracked) |
| `touch/screen-calc.sh` | Landscape width/height + DPI layer (tracked) |
| `packaging/` | Click launcher for testers |
| `patches/` | Optional unified diffs for this repo |
| `build/` | **Never on your machine** — Clickable SDK output only |

Reclaim disk after accidental builds: `./scripts/clean-local-artifacts.sh`

## Clickable testers

See [docs/TESTING.md](docs/TESTING.md).

```bash
clickable build --arch arm64
clickable install
```

For a **playable** test (maps/music), testers run `./scripts/fetch-sources.sh full` before `clickable build`, or maintainers document that requirement.

## Docs

- [docs/TESTING.md](docs/TESTING.md) — for Clickable community
- [docs/MAINTAINING.md](docs/MAINTAINING.md) — source-only maintainer guide
- [docs/SOURCES.md](docs/SOURCES.md) — where to edit UI and controls
- [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) — technical overview
- [docs/SCREEN.md](docs/SCREEN.md) — landscape screen calculation layer
