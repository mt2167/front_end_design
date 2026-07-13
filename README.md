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

## Next steps (open)

- Wire panels to real/mock state instead of static values
- Add a second screen under `screens/`, matching the dashboard's theme
  and concepts to another reference image
- Decide on state management approach as the app grows
