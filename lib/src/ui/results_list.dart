import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/filtered_provider.dart';
import '../providers/icon_resolver_provider.dart';
import '../providers/selection_provider.dart';
import 'app_icon.dart';

class ResultsList extends ConsumerStatefulWidget {
  const ResultsList({super.key});

  @override
  ConsumerState<ResultsList> createState() => _ResultsListState();
}

class _ResultsListState extends ConsumerState<ResultsList> {
  final ScrollController _scroll = ScrollController();
  static const double _rowHeight = 52.0;
  static const double _iconSize = 28.0;

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _ensureVisible(int index, int total) {
    if (!_scroll.hasClients || total == 0) return;
    final viewport = _scroll.position.viewportDimension;
    final offset = _scroll.offset;
    final top = index * _rowHeight;
    final bottom = top + _rowHeight;
    if (top < offset) {
      _scroll.jumpTo(top);
    } else if (bottom > offset + viewport) {
      _scroll.jumpTo(bottom - viewport);
    }
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(filteredEntriesProvider);
    final selected = ref.watch(selectedIndexProvider);
    final resolverAsync = ref.watch(iconResolverProvider);
    final resolver = resolverAsync.value;

    return async.when(
      loading: () => const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white54),
        ),
      ),
      error: (err, _) => Center(
        child: Text(
          'Failed to load entries: $err',
          style: const TextStyle(color: Colors.redAccent),
        ),
      ),
      data: (entries) {
        if (entries.isEmpty) {
          return const Center(
            child: Text(
              'No matches',
              style: TextStyle(color: Colors.white38),
            ),
          );
        }
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _ensureVisible(selected, entries.length);
        });
        return ListView.builder(
          controller: _scroll,
          itemExtent: _rowHeight,
          itemCount: entries.length,
          itemBuilder: (context, index) {
            final entry = entries[index];
            final isSelected = index == selected;
            final iconPath = resolver?.resolve(entry.icon);
            return InkWell(
              onTap: () =>
                  ref.read(selectedIndexProvider.notifier).setIndex(index),
              child: Container(
                height: _rowHeight,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.10)
                    : Colors.transparent,
                child: Row(
                  children: [
                    SizedBox(
                      width: _iconSize,
                      height: _iconSize,
                      child: AppIcon(path: iconPath, size: _iconSize),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.white70,
                              fontSize: 15,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                          if (entry.comment != null && entry.comment!.isNotEmpty)
                            Text(
                              entry.comment!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white38,
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
