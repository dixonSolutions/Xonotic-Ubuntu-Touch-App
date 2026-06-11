# Testing with Clickable

For **Ubuntu Touch / Clickable community testers** building and installing on device.

## Prerequisites

- [Clickable](https://github.com/ubports/clickable) installed
- Device with `adb` or Clickable device target
- Enough disk for SDK container + source (several GB)

## Standard build (UI / control changes)

Uses `code` fetch in prebuild (darkplaces, gmqcc, game QuakeC). Compiles inside the SDK — **not** on the maintainer's machine.

```bash
git clone <maintainer-repo-url>
cd Xonotic-Ubuntu-Touch-App
clickable build --arch arm64
clickable install
```

## Playable build (maps, music, full data)

If the app needs to load maps in-game:

```bash
./scripts/fetch-sources.sh full
clickable build --arch arm64
clickable install
```

`full` is a large download. Coordinate with the maintainer on whether this is required.

## Maintainer forks

If the maintainer uses forked upstream repos, set URLs before build:

```bash
export DARKPLACES_URL=https://gitlab.com/<user>/darkplaces.git
export DATA_URL=https://gitlab.com/<user>/xonotic-data.pk3dir.git
clickable build --arch arm64
```

Or apply patches from `patches/` before building (if provided).

## Applying `patches/`

```bash
for p in patches/*.patch; do
  [ -f "$p" ] && patch -p1 -d engine/darkplaces < "$p" || true
done
```

Adjust `-d` path per patch (document in patch header or maintainer notes).

## What gets installed

- `bin/xonotic` — compiled in SDK during `clickable build`
- `bin/start.sh` — launcher
- `data/` — from `engine/data` when present + `touch/xonotic.cfg`

## Screen / landscape

On launch, `bin/start.sh` logs lines like `xonotic-screen: landscape 2700x1224` to stderr. If resolution looks wrong, capture that line and `mirout` output from the device.

## Reporting issues

Include: device model, UT version, `clickable` log, screen-calc log line, whether build used `code` or `full` fetch, and steps to reproduce.
