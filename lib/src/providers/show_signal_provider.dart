import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'show_signal_provider.g.dart';

@Riverpod(keepAlive: true)
class ShowSignal extends _$ShowSignal {
  @override
  int build() => 0;

  void fire() => state = state + 1;
}
