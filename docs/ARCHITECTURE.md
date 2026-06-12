# Xonotic Adapted for Ubuntu Touch: Technical Architecture

Native C + QuakeC port. No Qt/QML. **Maintainers edit source only; Clickable community compiles.**

## 1. Roles

| Role | Compiles? | Actions |
|------|-----------|---------|
| Maintainer | No (by design) | Edit `engine/`, sync upstream forks, commit |
| Clickable tester | Yes (SDK) | `clickable build --arch arm64`, `clickable install` |

## 2. Core architecture

| Component | Location |
|-----------|----------|
| Engine | `engine/darkplaces/` (incl. `gettouchfinger`, `DP_UT_TOUCHFINGER`) |
| Menus / HUD / controls | `engine/data/xonotic-data.pk3dir/qcsrc/` |
| Touch defaults | `touch/xonotic.cfg` |
| Touch presets | `touch/profiles/*.cfg` → layout, feel, performance bundles |
| Screen layout | `touch/screen-calc.sh` → landscape `vid_width`/`vid_height`, DPI |
| Click package | Built in SDK → `bin/xonotic`, `bin/start.sh`, `data/` |

## 3. Repository layout

```
engine/              # Full Xonotic fork; UT changes integrated in-tree
touch/               # xonotic.cfg, screen-calc.sh, profiles/ (committed)
packaging/           # start.sh (committed)
build/               # SDK output only (gitignored)
scripts/             # fetch-sources.sh, sync-upstream-fork.sh (no compile)
```

## 4. Modification areas

- **Engine:** `engine/darkplaces/` — display, SDL, GLES, multitouch input
- **UI / controls:** `engine/data/xonotic-data.pk3dir/qcsrc/{menu,client,common}/`
- **Packaging:** `packaging/start.sh`, `touch/screen-calc.sh`, `manifest.json.in`
- **Landscape lock:** `manifest.json.in`, `X-Ubuntu-Supported-Orientations` in desktop file

## 5. Docs

- [MAINTAINING.md](MAINTAINING.md)
- [TESTING.md](TESTING.md)
- [SOURCES.md](SOURCES.md)
- [SCREEN.md](SCREEN.md)
- [CONTROLS.md](CONTROLS.md)
