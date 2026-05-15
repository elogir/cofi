import 'dart:io';

import '../desktop_entry/desktop_entry.dart';
import 'exec_tokeniser.dart';

class Launcher {
  Future<bool> launch(DesktopEntry entry) async {
    final tokens = tokeniseExec(entry.exec);
    if (tokens.isEmpty) return false;

    try {
      await Process.start(
        tokens.first,
        tokens.skip(1).toList(),
        mode: ProcessStartMode.detached,
        workingDirectory: (entry.workingDirectory?.isNotEmpty ?? false)
            ? entry.workingDirectory
            : null,
      );
      return true;
    } catch (_) {
      return false;
    }
  }
}
