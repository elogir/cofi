import 'dart:io';

import '../desktop_entry/desktop_entry.dart';

class Launcher {
  Future<bool> launch(DesktopEntry entry) async {
    try {
      await Process.start(
        'gio',
        ['launch', entry.sourcePath],
        mode: ProcessStartMode.detached,
      );
      return true;
    } catch (_) {
      return false;
    }
  }
}
