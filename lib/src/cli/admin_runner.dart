import 'dart:io';

import 'package:args/command_runner.dart';

import '../db/launch_database.dart';

class CofiRunner extends CommandRunner<int?> {
  CofiRunner()
      : super('cofi', 'A rofi-like launcher for Sway/Wayland.') {
    argParser.addFlag(
      'hide',
      help: 'Daemon mode: start with the window hidden (used at sway startup).',
      negatable: false,
    );
    addCommand(_DbCommand());
  }
}

bool isAdminInvocation(List<String> args) {
  for (final a in args) {
    if (a == 'db' || a == 'help' || a == '-h' || a == '--cofi-help') {
      return true;
    }
  }
  return false;
}

class _DbCommand extends Command<int?> {
  _DbCommand() {
    addSubcommand(_DbDumpCommand());
    addSubcommand(_DbResetCommand());
    addSubcommand(_DbSetCommand());
    addSubcommand(_DbDeleteCommand());
  }

  @override
  String get name => 'db';

  @override
  String get description =>
      'Inspect or modify the launch-count database (does not coordinate with a running daemon).';
}

class _DbDumpCommand extends Command<int?> {
  @override
  String get name => 'dump';

  @override
  String get description => 'Print every entry as: id<TAB>count<TAB>last_launched_iso';

  @override
  Future<int?> run() async {
    final db = LaunchDatabase.open();
    try {
      final rows = await db.all();
      rows.sort((a, b) => b.launchCount.compareTo(a.launchCount));
      for (final row in rows) {
        final ts = row.lastLaunchedAt?.toIso8601String() ?? '-';
        stdout.writeln('${row.id}\t${row.launchCount}\t$ts');
      }
      stderr.writeln('# ${rows.length} row(s) at ${resolveDatabasePath()}');
      return 0;
    } finally {
      await db.close();
    }
  }
}

class _DbResetCommand extends Command<int?> {
  @override
  String get name => 'reset';

  @override
  String get description => 'Delete all launch-count rows.';

  @override
  Future<int?> run() async {
    final db = LaunchDatabase.open();
    try {
      await db.resetAll();
      stderr.writeln('# cleared ${resolveDatabasePath()}');
      return 0;
    } finally {
      await db.close();
    }
  }
}

class _DbSetCommand extends Command<int?> {
  @override
  String get name => 'set';

  @override
  String get description => 'Set the launch count for an entry id.';

  @override
  String get invocation => '${runner!.executableName} db set <id> <count>';

  @override
  Future<int?> run() async {
    final rest = argResults!.rest;
    if (rest.length != 2) {
      stderr.writeln('usage: $invocation');
      return 64;
    }
    final id = rest[0];
    final count = int.tryParse(rest[1]);
    if (count == null || count < 0) {
      stderr.writeln('count must be a non-negative integer');
      return 64;
    }
    final db = LaunchDatabase.open();
    try {
      await db.setCount(id, count);
      stderr.writeln('# $id -> $count');
      return 0;
    } finally {
      await db.close();
    }
  }
}

class _DbDeleteCommand extends Command<int?> {
  @override
  String get name => 'delete';

  @override
  String get description => 'Remove the row for an entry id.';

  @override
  String get invocation => '${runner!.executableName} db delete <id>';

  @override
  Future<int?> run() async {
    final rest = argResults!.rest;
    if (rest.length != 1) {
      stderr.writeln('usage: $invocation');
      return 64;
    }
    final db = LaunchDatabase.open();
    try {
      await db.deleteEntry(rest.first);
      stderr.writeln('# deleted ${rest.first}');
      return 0;
    } finally {
      await db.close();
    }
  }
}
