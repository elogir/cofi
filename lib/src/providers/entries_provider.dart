import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../desktop_entry/desktop_entry.dart';
import '../desktop_entry/desktop_entry_loader.dart';

part 'entries_provider.g.dart';

@Riverpod(keepAlive: true)
Future<List<DesktopEntry>> desktopEntries(Ref ref) {
  return DesktopEntryLoader().load();
}
