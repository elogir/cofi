# cofi

A [rofi](https://github.com/davatorium/rofi)-like application launcher for
Sway/Wayland, written in Flutter. Fuzzy-search your installed apps, launch
on Enter, most-used apps surface first.

## Build

```bash
flutter pub get
dart run build_runner build
flutter build linux --release
```

Two binaries land in `build/linux/x64/release/bundle/`:

| binary         | role                                                |
|----------------|-----------------------------------------------------|
| `cofi`         | the launcher (Flutter); runs as a resident daemon   |
| `cofi-trigger` | tiny C client that asks the daemon to show itself   |

## Sway setup

Add to `~/.config/sway/config` (adjust paths):

```sway
for_window [app_id="dev.cofi.cofi"] floating enable
for_window [app_id="dev.cofi.cofi"] move position center
for_window [app_id="dev.cofi.cofi"] border none
for_window [app_id="dev.cofi.cofi"] focus

exec /path/to/cofi --hide               # warm the daemon at login
bindsym $mod+d exec /path/to/cofi-trigger
```

Reload with `$mod+Shift+c`. First trigger is instant after that
(daemon stays resident; trigger is a ~5 ms socket call).

## Keybindings

| Key                    | Action                       |
|------------------------|------------------------------|
| Up / Down or Ctrl+P/N  | move selection               |
| Page Up / Page Down    | move selection by 8          |
| Enter / click          | launch + hide                |
| Esc / Ctrl+G           | hide without launching       |
| (type)                 | fuzzy-search                 |

## CLI

Manage the launch-count store (`~/.local/share/cofi/launches.sqlite`):

```
cofi db dump                # id<TAB>count<TAB>iso, sorted by count desc
cofi db set <id> <count>    # set the count for an entry
cofi db delete <id>         # remove a row
cofi db reset               # delete all rows
cofi help                   # top-level usage
```

`<id>` is the `.desktop` filename without the extension.

Quit the daemon: `cofi-trigger --quit` or `pkill -f bundle/cofi`.

## Requirements

- Flutter 3.x desktop on Linux (GTK 3)
- `libsqlite3.so` or `libsqlite3.so.0`
- `gio` (from `glib2`) — used to launch `.desktop` entries
