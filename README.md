# J.A.R.V.I.S. AI OS Dashboard (Flutter)

A Flutter/Dart recreation of a sci-fi "AI OS" control dashboard UI —
originally built from a reference screenshot. This is the starting
point for a broader app.

## Structure

```
lib/
  main.dart                        # App entry point, theme setup
  theme.dart                       # Color palette + text styles (shared
                                    # across all screens)
  core/
    painters.dart                  # CustomPainters: neural sphere,
                                    # sparklines, bar charts, waveform,
                                    # gauge, network graph, dashed lines
    widgets.dart                   # Reusable UI pieces: panels, icon
                                    # badges, progress bars, tool tiles,
                                    # agent avatars, log rows, top bar items
  screens/
    dashboard/
      dashboard_screen.dart        # Full layout: top bar + left/center/
                                    # right columns matching the reference
                                    # dashboard image
```

`core/` holds anything shared across two or more screens (painters, generic
widgets, theme). Each screen gets its own folder under `screens/` — a
second screen goes in `screens/<name>/` alongside `dashboard/`.

## Status

Currently a static UI clone — all values (memory usage, CPU load,
task counts, etc.) are hardcoded to match the original screenshot,
not backed by live state or a data source yet.

## Running it

```
flutter pub get
flutter run
```

## Local Flutter SDK (repo-local)

This repo can use a local Flutter SDK under `.tools/flutter-sdk` so you do not
need a global Flutter install.

Install/update local SDK:

```bash
mkdir -p .tools
ARCHIVE_PATH=$(curl -fsSL https://storage.googleapis.com/flutter_infra_release/releases/releases_linux.json | grep -m1 -oE '"archive"\s*:\s*"[^"]+"' | sed -E 's/.*"([^"]+)"/\1/')
curl -fL "https://storage.googleapis.com/flutter_infra_release/releases/$ARCHIVE_PATH" -o .tools/flutter_sdk.tar.xz
tar -xJf .tools/flutter_sdk.tar.xz -C .tools
rm -f .tools/flutter_sdk.tar.xz
rm -rf .tools/flutter-sdk
mv .tools/flutter .tools/flutter-sdk
```

Run Flutter commands with the local SDK:

```bash
./.tools/flutter-sdk/bin/flutter pub get
./.tools/flutter-sdk/bin/flutter run
```

## Next steps (open)

- Wire panels to real/mock state instead of static values
- Add a second screen under `screens/`, matching the dashboard's theme
  and concepts to another reference image
- Decide on state management approach as the app grows
