import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selection_provider.g.dart';

@riverpod
class SelectedIndex extends _$SelectedIndex {
  @override
  int build() => 0;

  void reset() => state = 0;

  void move(int delta, int length) {
    if (length <= 0) {
      state = 0;
      return;
    }
    final next = state + delta;
    if (next < 0) {
      state = 0;
    } else if (next >= length) {
      state = length - 1;
    } else {
      state = next;
    }
  }

  void setIndex(int index) {
    state = index < 0 ? 0 : index;
  }
}
