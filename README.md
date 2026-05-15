# cofi

A [rofi](https://github.com/davatorium/rofi)-like application launcher for
Sway/Wayland, written in Flutter.

MVP scope is `drun` only: scan `.desktop` files from the standard XDG paths,
fuzzy-search by name/keywords/comment, launch the chosen entry on `Enter`,
dismiss on `Esc` (or when the window loses focus).

State is managed exclusively via the `riverpod_generator` (`@riverpod`
annotations). Package versions in `pubspec.yaml` are intentionally unpinned —
`flutter pub get` resolves to whatever is latest.

## Build

```bash
flutter pub get
dart run build_runner build
flutter build linux --release
```

The release binary lands at:

```
build/linux/x64/release/bundle/cofi
```

For development:

```bash
dart run build_runner watch   # one terminal — regenerates *.g.dart on save
flutter run -d linux          # another terminal
```

## Sway integration

Add to `~/.config/sway/config`:

```sway
for_window [app_id="dev.cofi.cofi"] floating enable
for_window [app_id="dev.cofi.cofi"] move position center
for_window [app_id="dev.cofi.cofi"] border none
for_window [app_id="dev.cofi.cofi"] focus

# Pre-warm at session start so the first trigger is instant.
exec /full/path/to/cofi/build/linux/x64/release/bundle/cofi --hide

# Trigger: use the tiny C client (cofi-trigger, ~5 ms) instead of the
# Flutter binary (~100 ms) so the keypress feels instant.
bindsym $mod+d exec /full/path/to/cofi/build/linux/x64/release/bundle/cofi-trigger
```

If you want the bindsym to also auto-spawn the daemon when it isn't
running yet, use the fallback form:

```sway
bindsym $mod+d exec sh -c '/path/to/cofi-trigger || /path/to/cofi'
```

`cofi-trigger` exits with status 2 when the daemon isn't reachable, so
the `||` falls through to a cold start.

Reload sway (`$mod+Shift+c`). Trigger with `$mod+d`.

Sway sometimes doesn't auto-focus newly-mapped floating windows; the
`focus` rule above is a workaround. The Wayland `app_id` is set via the GTK
application id in `linux/runner/my_application.cc` and is exposed as
`dev.cofi.cofi`. Verify with:

```bash
swaymsg -t get_tree | grep app_id
```

## Daemon / single-process model

cofi avoids re-paying the Flutter engine cold-start cost (~200-300 ms) on
every trigger by staying resident:

- The **first invocation** binds a Unix-domain socket at
  `$XDG_RUNTIME_DIR/cofi.sock` (or `/tmp/cofi-$USER.sock` as fallback),
  runs the full widget tree, and shows the window. Dismissing the window
  (Esc / Ctrl+G / launching an app / focus loss) **hides** it instead of
  exiting — the process stays alive.
- **Subsequent triggers** use `cofi-trigger`, a tiny C client built
  alongside the bundle. It connects to the socket, writes one of three
  commands, and exits in ~3-5 ms — no Dart VM, no GTK, just `socket()` →
  `connect()` → `write()`:
  - `cofi-trigger` (no args) — sends `show`. Daemon resets query, scrolls
    to top, refocuses the search field, and remaps the window via the
    `dev.cofi.cofi/window` platform channel.
  - `cofi-trigger --hide` — probe-only; useful in scripts checking
    whether the daemon is up.
  - `cofi-trigger --quit` — graceful shutdown.
- The flag `--hide` on the **Flutter binary** tells the daemon to start
  with the window hidden (used by sway's `exec` at session start). The
  flag has the same name on `cofi-trigger` but means "no-op probe" — the
  two binaries play distinct roles.
- Cold start applies once per session; every trigger after that is
  ~5 ms client + ~20-40 ms GTK remap + Wayland focus → well under the
  ~50 ms perceptual threshold.
- Quit the daemon with `cofi-trigger --quit` or `SIGTERM` (e.g.
  `pkill -f bundle/cofi`); both clean up the socket file.

If the socket file is stale (process died without cleanup) it's unlinked
and re-bound automatically on the next start of the Flutter binary.

## Keybindings

| Key                       | Action                            |
|---------------------------|-----------------------------------|
| Up / Down                 | Move selection                    |
| Page Up / Page Down       | Move selection by 8               |
| Enter / Keypad Enter      | Launch selected entry, then exit  |
| Esc                       | Exit without launching            |
| (any other char)          | Append to query                   |

The window also exits when it loses focus (matches rofi's dismiss-on-blur
behaviour).

## How entries are discovered

`.desktop` files are read from `applications/` subdirectories of, in priority
order:

1. `$XDG_DATA_HOME` (default `~/.local/share`)
2. `~/.local/share/flatpak/exports/share`
3. `/var/lib/flatpak/exports/share`
4. Each entry in `$XDG_DATA_DIRS` (default `/usr/local/share:/usr/share`)

Earlier directories shadow later ones (by `.desktop` basename), so user
overrides win.

Entries are skipped when any of these apply:

- `Type` is not `Application`
- `Hidden=true` or `NoDisplay=true`
- `OnlyShowIn` is set and doesn't include `$XDG_CURRENT_DESKTOP` (Sway sets
  this to `sway`)
- `NotShowIn` contains `$XDG_CURRENT_DESKTOP`
- `TryExec` is set and the named binary isn't on `$PATH`
- `Terminal=true` (TUI apps like nano/htop are hidden by design)

`Exec` is tokenised respecting `"…"` quoting and the field codes `%f %F %u
%U %i %c %k %d %D %n %N %v %m` are stripped (`%%` becomes a literal `%`).

## Icons

`.desktop` `Icon=` values are resolved via a one-shot scan at startup:

- Themes are searched under `$XDG_DATA_HOME/icons`, `~/.icons`, and each
  `$XDG_DATA_DIRS/icons` (default `/usr/local/share/icons`, `/usr/share/icons`)
- Only `theme/<size>/apps/*.{png,svg,xpm}` files are read — not the whole tree
- A scoring function ranks candidates by size (48×48 preferred, then scalable,
  then 64×64, etc.), then theme (`hicolor` ≻ `Adwaita` ≻ `Papirus` ≻ others),
  with symbolic icons heavily de-ranked
- `/usr/share/pixmaps` is the final fallback
- Absolute `Icon=` paths are used verbatim
- SVG icons render via `flutter_svg`; PNG/JPG via `Image.file`; XPM is ignored

## Limitations / non-goals (for now)

- **No other rofi modes.** No `run`, `window`, `ssh`, `combi`, etc.
- **No theming / config file.** Colours are baked in.
- **Cold-start latency.** Flutter desktop starts in ~200–500 ms versus
  rofi's ~20 ms. Noticeable but acceptable for an MVP.

## Architecture

```
lib/
  main.dart                              # ProviderScope + dismiss-on-blur observer
  src/
    desktop_entry/
      desktop_entry.dart                 # data class
      desktop_entry_parser.dart          # INI parse + Hidden/NoDisplay/OnlyShowIn/TryExec filters
      desktop_entry_loader.dart          # XDG path enumeration, dedup by basename
    search/
      fuzzy_matcher.dart                 # subsequence scoring (name > keywords > comment)
    launcher/
      exec_tokeniser.dart                # quote-aware split + %-code stripping
      launcher.dart                      # Process.start(detached) with terminal wrapping
    providers/                           # all @riverpod, all paired with *.g.dart
      entries_provider.dart              # Future<List<DesktopEntry>> — keepAlive
      query_provider.dart                # Notifier<String>; resets selection on change
      filtered_provider.dart             # Future<List<DesktopEntry>> derived
      selection_provider.dart            # Notifier<int> — move/reset/setIndex
    ui/
      cofi_window.dart                   # Focus + key handler (beats TextField for arrows)
      search_field.dart                  # TextField bound to queryProvider
      results_list.dart                  # ListView consuming filtered + selection
```

All providers are declared via `@riverpod` annotations (functions or Notifier
classes). There is no manual `Provider(...)` / `StateNotifierProvider(...)`
syntax anywhere in the codebase. `dart run build_runner build` produces the
matching `*.g.dart` files.
