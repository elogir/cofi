import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../db/launch_database.dart';

part 'launch_counts_provider.g.dart';

@Riverpod(keepAlive: true)
class LaunchCounts extends _$LaunchCounts {
  LaunchDatabase? _db;

  @override
  Future<Map<String, int>> build() async {
    final db = LaunchDatabase.open();
    _db = db;
    ref.onDispose(() async {
      await db.close();
    });
    return db.countsByid();
  }

  Future<void> increment(String id) async {
    final db = _db;
    if (db == null) return;
    await db.incrementCount(id);
    final current = await future;
    state = AsyncData({
      ...current,
      id: (current[id] ?? 0) + 1,
    });
  }
}
