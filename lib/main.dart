import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/ui/cofi_window.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding.instance.addObserver(_DismissOnBlur());
  runApp(const ProviderScope(child: CofiApp()));
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

class _DismissOnBlur with WidgetsBindingObserver {
  bool _hasBeenResumed = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _hasBeenResumed = true;
      return;
    }
    if (!_hasBeenResumed) return;
    if (state == AppLifecycleState.hidden ||
        state == AppLifecycleState.paused) {
      exit(0);
    }
  }
}
