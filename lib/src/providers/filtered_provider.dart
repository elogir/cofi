import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../desktop_entry/desktop_entry.dart';
import '../search/fuzzy_matcher.dart';
import 'entries_provider.dart';
import 'launch_counts_provider.dart';
import 'query_provider.dart';

part 'filtered_provider.g.dart';

@riverpod
Future<List<DesktopEntry>> filteredEntries(Ref ref) async {
  final entries = await ref.watch(desktopEntriesProvider.future);
  final query = ref.watch(queryProvider);
  final counts = await ref.watch(launchCountsProvider.future);
  return fuzzyFilter(entries, query, counts);
}
