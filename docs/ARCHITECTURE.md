# Xonotic Adapted for Ubuntu Touch: Technical Architecture

Native C + QuakeC port. No Qt/QML. **Maintainers edit source only; Clickable community compiles.**

## 1. Roles

| Role | Compiles? | Actions |
|------|-----------|---------|
| Maintainer | No (by design) | `fetch-sources.sh`, edit `engine/`, push forks or `patches/` |
| Clickable tester | Yes (SDK) | `clickable build --arch arm64`, `clickable install` |

## 2. Core architecture

| Component | Location |
|-----------|----------|
| Engine | `engine/darkplaces/` |
| Menus / HUD / controls | `engine/data/xonotic-data.pk3dir/qcsrc/` |
| Touch defaults | `touch/xonotic.cfg` |
| Screen layout | `touch/screen-calc.sh` → landscape `vid_width`/`vid_height`, DPI |
| Click package | Built in SDK → `bin/xonotic`, `bin/start.sh`, `data/` |

## 3. Repository layout

```
engine/              # fetched upstream (not committed)
touch/               # xonotic.cfg + screen-calc.sh (committed)
packaging/           # start.sh (committed)
patches/             # optional diffs (committed)
build/               # SDK output only (gitignored)
scripts/             # fetch-sources.sh (no compile)
```

## 4. Modification areas

- **Engine:** `engine/darkplaces/` — display, SDL, GLES, input
- **UI / controls:** `qcsrc/menu/`, `qcsrc/client/`, `qcsrc/common/`
- **Packaging:** `packaging/start.sh`, `touch/screen-calc.sh`, `manifest.json.in`
- **Landscape lock:** `manifest.json.in`, `X-Ubuntu-Supported-Orientations` in desktop file

## 5. Docs

- [MAINTAINING.md](MAINTAINING.md)
- [TESTING.md](TESTING.md)
- [SOURCES.md](SOURCES.md)
- [SCREEN.md](SCREEN.md)
