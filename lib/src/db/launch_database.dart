import 'dart:ffi';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/open.dart' as sqlite_open;

part 'launch_database.g.dart';

@DataClassName('AppLaunch')
class AppLaunches extends Table {
  TextColumn get id => text()();
  IntColumn get launchCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastLaunchedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [AppLaunches])
class LaunchDatabase extends _$LaunchDatabase {
  LaunchDatabase(super.e);

  factory LaunchDatabase.open() {
    _ensureSqliteLoader();
    final path = resolveDatabasePath();
    final dir = Directory(p.dirname(path));
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
    return LaunchDatabase(NativeDatabase(File(path)));
  }

  @override
  int get schemaVersion => 1;

  Future<List<AppLaunch>> all() => select(appLaunches).get();

  Future<AppLaunch?> get(String id) =>
      (select(appLaunches)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<Map<String, int>> countsByid() async {
    final rows = await all();
    return {for (final r in rows) r.id: r.launchCount};
  }

  Future<void> incrementCount(String id) async {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    await customStatement(
      'INSERT INTO app_launches (id, launch_count, last_launched_at) '
      'VALUES (?, 1, ?) '
      'ON CONFLICT(id) DO UPDATE SET '
      'launch_count = app_launches.launch_count + 1, '
      'last_launched_at = excluded.last_launched_at',
      [id, now],
    );
  }

  Future<void> setCount(String id, int count) async {
    final now = DateTime.now();
    await into(appLaunches).insertOnConflictUpdate(
      AppLaunchesCompanion.insert(
        id: id,
        launchCount: Value(count),
        lastLaunchedAt: Value(now),
      ),
    );
  }

  Future<void> deleteEntry(String id) =>
      (delete(appLaunches)..where((t) => t.id.equals(id))).go();

  Future<void> resetAll() => delete(appLaunches).go();
}

var _sqliteLoaderConfigured = false;

void _ensureSqliteLoader() {
  if (_sqliteLoaderConfigured) return;
  _sqliteLoaderConfigured = true;
  sqlite_open.open.overrideForAll(() {
    for (final name in const ['libsqlite3.so', 'libsqlite3.so.0']) {
      try {
        return DynamicLibrary.open(name);
      } catch (_) {
        // try next candidate
      }
    }
    throw StateError(
      'cofi: libsqlite3 not found (tried libsqlite3.so, libsqlite3.so.0)',
    );
  });
}

String resolveDatabasePath() {
  final env = Platform.environment;
  final home = env['HOME'] ?? '';
  final dataHome = (env['XDG_DATA_HOME']?.isNotEmpty ?? false)
      ? env['XDG_DATA_HOME']!
      : '$home/.local/share';
  return p.join(dataHome, 'cofi', 'launches.sqlite');
}
