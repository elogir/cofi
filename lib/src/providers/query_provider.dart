import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'selection_provider.dart';

part 'query_provider.g.dart';

@riverpod
class Query extends _$Query {
  @override
  String build() => '';

  void set(String value) {
    if (state == value) return;
    state = value;
    ref.read(selectedIndexProvider.notifier).reset();
  }
}
