# Source layout and modification guide

No binaries in this repo. Clone source into `engine/` with `./scripts/fetch-sources.sh` — **no compile**.

## Upstream repositories

| Tree | Repository | Touch port work |
|------|------------|-----------------|
| `engine/darkplaces/` | [darkplaces](https://gitlab.com/xonotic/darkplaces) | SDL, GLES, low-level input |
| `engine/data/xonotic-data.pk3dir/qcsrc/menu/` | [xonotic-data.pk3dir](https://gitlab.com/xonotic/xonotic-data.pk3dir) | Menu layout |
| `engine/data/xonotic-data.pk3dir/qcsrc/client/` | same | HUD, in-game UI, CSQC |
| `engine/data/xonotic-data.pk3dir/qcsrc/common/` | same | Shared input / constants |
| `engine/gmqcc/` | [gmqcc](https://gitlab.com/xonotic/gmqcc) | QuakeC compiler (testers build this) |

## Fetch modes (maintainers)

```bash
./scripts/fetch-sources.sh minimal   # darkplaces only
./scripts/fetch-sources.sh code      # UI + QuakeC + engine (default)
./scripts/fetch-sources.sh full      # entire game + maps (testers, large)
```

## Building

**Maintainers:** do not compile locally — see [MAINTAINING.md](MAINTAINING.md).

**Testers:** `clickable build --arch arm64` — see [TESTING.md](TESTING.md).

## Port-specific files (this repo)

- `touch/xonotic.cfg` — gameplay / graphics cvars
- `touch/screen-calc.sh` — landscape resolution and DPI ([SCREEN.md](SCREEN.md))
- `packaging/start.sh` — click launcher
- `patches/` — optional diffs for reviewers

QuakeC HUD layout should use `vid_width`, `vid_height`, and touch DPI cvars set at launch—not fixed 1920×1080.
