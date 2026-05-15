import 'dart:io';

import 'desktop_entry.dart';

class DesktopEntryParser {
  DesktopEntryParser({String? currentDesktop, List<String>? pathEntries})
      : _currentDesktop = (currentDesktop ??
            Platform.environment['XDG_CURRENT_DESKTOP'] ??
            '')
            .split(':')
            .where((s) => s.isNotEmpty)
            .toSet(),
        _pathEntries = pathEntries ??
            (Platform.environment['PATH'] ?? '')
                .split(':')
                .where((s) => s.isNotEmpty)
                .toList();

  final Set<String> _currentDesktop;
  final List<String> _pathEntries;

  DesktopEntry? parse(File file) {
    final lines = file.readAsLinesSync();
    final fields = <String, String>{};
    var inSection = false;

    for (final raw in lines) {
      final line = raw.trim();
      if (line.isEmpty || line.startsWith('#')) continue;
      if (line.startsWith('[')) {
        if (inSection) break;
        inSection = line == '[Desktop Entry]';
        continue;
      }
      if (!inSection) continue;
      final eq = line.indexOf('=');
      if (eq <= 0) continue;
      final key = line.substring(0, eq).trim();
      if (fields.containsKey(key)) continue;
      fields[key] = _unescapeFileValue(line.substring(eq + 1).trim());
    }

    if ((fields['Type'] ?? '') != 'Application') return null;
    if (_truthy(fields['Hidden'])) return null;
    if (_truthy(fields['NoDisplay'])) return null;
    if (_truthy(fields['Terminal'])) return null;

    final onlyShowIn = _splitList(fields['OnlyShowIn']);
    if (onlyShowIn.isNotEmpty &&
        !onlyShowIn.any(_currentDesktop.contains)) {
      return null;
    }
    final notShowIn = _splitList(fields['NotShowIn']);
    if (notShowIn.any(_currentDesktop.contains)) return null;

    final tryExec = fields['TryExec'];
    if (tryExec != null && tryExec.isNotEmpty && !_canExecute(tryExec)) {
      return null;
    }

    final exec = fields['Exec'];
    final name = fields['Name'];
    if (exec == null || exec.isEmpty || name == null || name.isEmpty) {
      return null;
    }

    return DesktopEntry(
      id: _basenameWithoutExtension(file.path),
      name: name,
      comment: fields['Comment'],
      icon: (fields['Icon']?.isNotEmpty ?? false) ? fields['Icon'] : null,
      keywords: _splitList(fields['Keywords']),
      sourcePath: file.path,
    );
  }

  // File-level unescape per XDG Desktop Entry Specification, "Value types":
  //   \\ -> \   \s -> SPACE   \n -> LF   \t -> TAB   \r -> CR
  // This is applied before any Exec-level tokenisation.
  String _unescapeFileValue(String raw) {
    if (!raw.contains(r'\')) return raw;
    final out = StringBuffer();
    var i = 0;
    while (i < raw.length) {
      final ch = raw[i];
      if (ch == r'\' && i + 1 < raw.length) {
        final next = raw[i + 1];
        switch (next) {
          case r'\':
            out.write(r'\');
            i += 2;
            continue;
          case 's':
            out.write(' ');
            i += 2;
            continue;
          case 'n':
            out.write('\n');
            i += 2;
            continue;
          case 't':
            out.write('\t');
            i += 2;
            continue;
          case 'r':
            out.write('\r');
            i += 2;
            continue;
        }
      }
      out.write(ch);
      i++;
    }
    return out.toString();
  }

  bool _truthy(String? value) => value?.toLowerCase() == 'true';

  List<String> _splitList(String? value) {
    if (value == null || value.isEmpty) return const [];
    return value
        .split(';')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
  }

  bool _canExecute(String binary) {
    if (binary.contains('/')) {
      final file = File(binary);
      return file.existsSync();
    }
    for (final dir in _pathEntries) {
      if (File('$dir/$binary').existsSync()) return true;
    }
    return false;
  }

  String _basenameWithoutExtension(String path) {
    final slash = path.lastIndexOf('/');
    var name = slash >= 0 ? path.substring(slash + 1) : path;
    final dot = name.lastIndexOf('.');
    if (dot > 0) name = name.substring(0, dot);
    return name;
  }
}
