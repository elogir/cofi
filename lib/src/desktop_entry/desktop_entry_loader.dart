import 'dart:io';

import 'desktop_entry.dart';
import 'desktop_entry_parser.dart';

class DesktopEntryLoader {
  DesktopEntryLoader({DesktopEntryParser? parser})
      : _parser = parser ?? DesktopEntryParser();

  final DesktopEntryParser _parser;

  Future<List<DesktopEntry>> load() async {
    final dirs = _searchDirs();
    final seen = <String, DesktopEntry>{};

    for (final dir in dirs) {
      final directory = Directory(dir);
      if (!directory.existsSync()) continue;
      await for (final entity in directory.list(recursive: true, followLinks: false)) {
        if (entity is! File) continue;
        if (!entity.path.endsWith('.desktop')) continue;
        try {
          final entry = _parser.parse(entity);
          if (entry == null) continue;
          seen.putIfAbsent(entry.id, () => entry);
        } catch (_) {
          // Skip unreadable / malformed files.
        }
      }
    }

    final list = seen.values.toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return list;
  }

  List<String> _searchDirs() {
    final env = Platform.environment;
    final home = env['HOME'] ?? '';
    final dataHome = (env['XDG_DATA_HOME'] != null && env['XDG_DATA_HOME']!.isNotEmpty)
        ? env['XDG_DATA_HOME']!
        : '$home/.local/share';
    final dataDirs = (env['XDG_DATA_DIRS'] != null && env['XDG_DATA_DIRS']!.isNotEmpty)
        ? env['XDG_DATA_DIRS']!.split(':')
        : <String>['/usr/local/share', '/usr/share'];

    final flatpakUser = '$home/.local/share/flatpak/exports/share';
    const flatpakSystem = '/var/lib/flatpak/exports/share';

    final roots = <String>[
      dataHome,
      flatpakUser,
      flatpakSystem,
      ...dataDirs,
    ];

    final seen = <String>{};
    final dirs = <String>[];
    for (final root in roots) {
      final dir = '$root/applications';
      if (seen.add(dir)) dirs.add(dir);
    }
    return dirs;
  }
}
