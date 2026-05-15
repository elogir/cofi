// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'show_signal_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ShowSignal)
final showSignalProvider = ShowSignalProvider._();

final class ShowSignalProvider extends $NotifierProvider<ShowSignal, int> {
  ShowSignalProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'showSignalProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$showSignalHash();

  @$internal
  @override
  ShowSignal create() => ShowSignal();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$showSignalHash() => r'fdef2fee18b27b914239e3a0961b78e5d033f3dc';

abstract class _$ShowSignal extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
