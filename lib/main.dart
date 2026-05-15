import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/cli/admin_runner.dart';
import 'src/providers/show_signal_provider.dart';
import 'src/ui/cofi_window.dart';

String _socketPath() {
  final runtime = Platform.environment['XDG_RUNTIME_DIR'];
  if (runtime != null && runtime.isNotEmpty) return '$runtime/cofi.sock';
  final user = Platform.environment['USER'] ?? 'user';
  return '/tmp/cofi-$user.sock';
}

Future<bool> _runClient(List<String> args) async {
  final addr = InternetAddress(_socketPath(), type: InternetAddressType.unix);
  try {
    final socket = await Socket.connect(
      addr,
      0,
      timeout: const Duration(milliseconds: 250),
    );
    final command = args.contains('--hide') ? 'noop' : 'show';
    socket.add(utf8.encode('$command\n'));
    await socket.flush();
    await socket.close();
    return true;
  } catch (_) {
    return false;
  }
}

void _unlinkSocket() {
  try {
    File(_socketPath()).deleteSync();
  } catch (_) {}
}

Future<ServerSocket?> _bindServer() async {
  final addr = InternetAddress(_socketPath(), type: InternetAddressType.unix);
  try {
    return await ServerSocket.bind(addr, 0);
  } catch (_) {
    _unlinkSocket();
    try {
      return await ServerSocket.bind(addr, 0);
    } catch (_) {
      return null;
    }
  }
}

Future<void> main(List<String> args) async {
  if (isAdminInvocation(args)) {
    final code = await CofiRunner().run(args);
    exit(code ?? 0);
  }

  if (await _runClient(args)) {
    exit(0);
  }

  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();

  final server = await _bindServer();
  if (server == null) {
    stderr.writeln('cofi: failed to bind ${_socketPath()}');
    exit(1);
  }

  server.listen((client) async {
    final chunks = <int>[];
    await for (final chunk in client) {
      chunks.addAll(chunk);
      if (chunks.length > 64) break;
    }
    final command = utf8.decode(chunks).trim();
    if (command == 'show') {
      container.read(showSignalProvider.notifier).fire();
    } else if (command == 'quit') {
      _unlinkSocket();
      exit(0);
    }
    try {
      await client.close();
    } catch (_) {}
  });

  for (final sig in [ProcessSignal.sigterm, ProcessSignal.sigint]) {
    sig.watch().listen((_) {
      _unlinkSocket();
      exit(0);
    });
  }

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const CofiApp(),
    ),
  );
}

class CofiApp extends StatelessWidget {
  const CofiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'cofi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: const Color(0xFF1B1D23),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.white70,
          selectionColor: Color(0x33FFFFFF),
        ),
      ),
      home: const CofiWindow(),
    );
  }
}
