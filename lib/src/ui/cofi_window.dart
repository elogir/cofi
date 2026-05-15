import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../launcher/launcher.dart';
import '../providers/filtered_provider.dart';
import '../providers/launch_counts_provider.dart';
import '../providers/query_provider.dart';
import '../providers/selection_provider.dart';
import '../providers/show_signal_provider.dart';
import 'results_list.dart';
import 'search_field.dart';

const MethodChannel _windowChannel = MethodChannel('dev.cofi.cofi/window');

class CofiWindow extends ConsumerStatefulWidget {
  const CofiWindow({super.key});

  @override
  ConsumerState<CofiWindow> createState() => _CofiWindowState();
}

class _CofiWindowState extends ConsumerState<CofiWindow> {
  final FocusNode _shellNode = FocusNode(debugLabel: 'cofi-shell');
  final FocusNode _searchNode = FocusNode(debugLabel: 'cofi-search');
  final Launcher _launcher = Launcher();

  @override
  void dispose() {
    _shellNode.dispose();
    _searchNode.dispose();
    super.dispose();
  }

  Future<void> _hide() async {
    try {
      await _windowChannel.invokeMethod('hide');
    } catch (_) {}
  }

  Future<void> _show() async {
    try {
      await _windowChannel.invokeMethod('show');
    } catch (_) {}
  }

  void _resetState() {
    ref.read(queryProvider.notifier).set('');
    ref.read(selectedIndexProvider.notifier).reset();
  }

  Future<void> _onShowRequested() async {
    _resetState();
    await _show();
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _searchNode.requestFocus();
    });
  }

  Future<void> _launchSelected() async {
    final async = ref.read(filteredEntriesProvider);
    final entries = async.value;
    if (entries == null || entries.isEmpty) return;
    final index = ref.read(selectedIndexProvider);
    if (index < 0 || index >= entries.length) return;
    final entry = entries[index];
    final ok = await _launcher.launch(entry);
    if (ok) {
      try {
        await ref.read(launchCountsProvider.notifier).increment(entry.id);
      } catch (e, st) {
        stderr.writeln('cofi: failed to increment launch count for ${entry.id}: $e\n$st');
      }
      await _hide();
    }
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    final key = event.logicalKey;
    final isCtrl = HardwareKeyboard.instance.isControlPressed;

    if (key == LogicalKeyboardKey.escape ||
        (isCtrl && key == LogicalKeyboardKey.keyG)) {
      _hide();
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.numpadEnter) {
      _launchSelected();
      return KeyEventResult.handled;
    }
    final isDown = key == LogicalKeyboardKey.arrowDown ||
        (isCtrl && key == LogicalKeyboardKey.keyN);
    final isUp = key == LogicalKeyboardKey.arrowUp ||
        (isCtrl && key == LogicalKeyboardKey.keyP);
    if (isDown) {
      final length = ref.read(filteredEntriesProvider).value?.length ?? 0;
      ref.read(selectedIndexProvider.notifier).move(1, length);
      return KeyEventResult.handled;
    }
    if (isUp) {
      final length = ref.read(filteredEntriesProvider).value?.length ?? 0;
      ref.read(selectedIndexProvider.notifier).move(-1, length);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.pageDown) {
      final length = ref.read(filteredEntriesProvider).value?.length ?? 0;
      ref.read(selectedIndexProvider.notifier).move(8, length);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.pageUp) {
      final length = ref.read(filteredEntriesProvider).value?.length ?? 0;
      ref.read(selectedIndexProvider.notifier).move(-8, length);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<int>(showSignalProvider, (_, _) {
      _onShowRequested();
    });
    return Focus(
      focusNode: _shellNode,
      onKeyEvent: _onKey,
      child: Material(
        color: const Color(0xFF1B1D23),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color(0xFF2A2D36), width: 1),
                  ),
                ),
                child: SearchField(focusNode: _searchNode),
              ),
              const Expanded(child: ResultsList()),
            ],
          ),
        ),
      ),
    );
  }
}
