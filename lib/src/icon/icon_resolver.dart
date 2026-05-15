import 'dart:io';

class IconResolver {
  IconResolver._(this._byName);

  final Map<String, String> _byName;

  static const _exts = <String>['.png', '.svg', '.xpm'];

  static const _sizePref = <String, int>{
    '48x48': 100,
    '48': 100,
    'scalable': 90,
    '64x64': 80,
    '64': 80,
    '32x32': 70,
    '32': 70,
    '128x128': 60,
    '128': 60,
    '24x24': 50,
    '24': 50,
    '256x256': 40,
    '256': 40,
    '16x16': 30,
    '16': 30,
    '512x512': 20,
    '512': 20,
  };

  static Future<IconResolver> create() async {
    final scored = <String, _Candidate>{};

    for (final root in _iconRoots()) {
      final rootDir = Directory(root);
      if (!_existsSafely(rootDir)) continue;
      for (final themeEntity in _listSafely(rootDir)) {
        if (themeEntity is! Directory) continue;
        final themeName = _basename(themeEntity.path);
        for (final sizeEntity in _listSafely(themeEntity)) {
          if (sizeEntity is! Directory) continue;
          final sizeName = _basename(sizeEntity.path);
          final appsDir = Directory('${sizeEntity.path}/apps');
          if (!_existsSafely(appsDir)) continue;
          for (final file in _listSafely(appsDir)) {
            if (file is! File) continue;
            _consider(scored, file.path, themeName: themeName, sizeName: sizeName);
          }
        }
      }
    }

    for (final pixmaps in _pixmapDirs()) {
      final dir = Directory(pixmaps);
      if (!_existsSafely(dir)) continue;
      for (final file in _listSafely(dir)) {
        if (file is! File) continue;
        _consider(scored, file.path, themeName: '', sizeName: 'pixmaps');
      }
    }

    return IconResolver._({
      for (final entry in scored.entries) entry.key: entry.value.path,
    });
  }

  String? resolve(String? iconField) {
    if (iconField == null || iconField.isEmpty) return null;
    if (iconField.startsWith('/')) {
      return File(iconField).existsSync() ? iconField : null;
    }
    final name = _stripKnownExtension(iconField);
    return _byName[name];
  }

  static void _consider(
    Map<String, _Candidate> scored,
    String path, {
    required String themeName,
    required String sizeName,
  }) {
    final lower = path.toLowerCase();
    final dotIdx = lower.lastIndexOf('.');
    if (dotIdx < 0) return;
    final ext = lower.substring(dotIdx);
    if (!_exts.contains(ext)) return;
    final slashIdx = path.lastIndexOf('/');
    final name = path.substring(slashIdx + 1, dotIdx);

    var score = _sizePref[sizeName] ?? 5;
    if (themeName == 'hicolor') score += 25;
    if (themeName == 'Adwaita') score += 15;
    if (themeName == 'Papirus') score += 15;
    if (themeName == 'breeze') score += 10;
    if (sizeName == 'pixmaps') score += 5;
    if (lower.contains('symbolic')) score -= 200;
    if (ext == '.svg') score += 3;

    final existing = scored[name];
    if (existing == null || existing.score < score) {
      scored[name] = _Candidate(path, score);
    }
  }

  static List<String> _iconRoots() {
    final env = Platform.environment;
    final home = env['HOME'] ?? '';
    final dataHome = (env['XDG_DATA_HOME']?.isNotEmpty ?? false)
        ? env['XDG_DATA_HOME']!
        : '$home/.local/share';
    final dataDirs = (env['XDG_DATA_DIRS']?.isNotEmpty ?? false)
        ? env['XDG_DATA_DIRS']!.split(':')
        : const <String>['/usr/local/share', '/usr/share'];

    final seen = <String>{};
    final result = <String>[];
    void add(String path) {
      if (seen.add(path)) result.add(path);
    }

    add('$dataHome/icons');
    add('$home/.icons');
    for (final dir in dataDirs) {
      add('$dir/icons');
    }
    return result;
  }

  static List<String> _pixmapDirs() {
    final env = Platform.environment;
    final dataDirs = (env['XDG_DATA_DIRS']?.isNotEmpty ?? false)
        ? env['XDG_DATA_DIRS']!.split(':')
        : const <String>['/usr/local/share', '/usr/share'];
    final seen = <String>{};
    final result = <String>[];
    for (final d in dataDirs) {
      final path = '$d/pixmaps';
      if (seen.add(path)) result.add(path);
    }
    if (seen.add('/usr/share/pixmaps')) result.add('/usr/share/pixmaps');
    return result;
  }

  static bool _existsSafely(Directory d) {
    try {
      return d.existsSync();
    } catch (_) {
      return false;
    }
  }

  static List<FileSystemEntity> _listSafely(Directory d) {
    try {
      return d.listSync(followLinks: true);
    } catch (_) {
      return const [];
    }
  }

  static String _basename(String path) {
    final i = path.lastIndexOf('/');
    return i >= 0 ? path.substring(i + 1) : path;
  }

  static String _stripKnownExtension(String name) {
    final lower = name.toLowerCase();
    for (final ext in _exts) {
      if (lower.endsWith(ext)) return name.substring(0, name.length - ext.length);
    }
    return name;
  }
}

class _Candidate {
  const _Candidate(this.path, this.score);
  final String path;
  final int score;
}
