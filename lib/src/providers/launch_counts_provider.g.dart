// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'launch_counts_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LaunchCounts)
final launchCountsProvider = LaunchCountsProvider._();

final class LaunchCountsProvider
    extends $AsyncNotifierProvider<LaunchCounts, Map<String, int>> {
  LaunchCountsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'launchCountsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$launchCountsHash();

  @$internal
  @override
  LaunchCounts create() => LaunchCounts();
}

String _$launchCountsHash() => r'235137695f6c151e853e56efe50dc407d139b3a4';

abstract class _$LaunchCounts extends $AsyncNotifier<Map<String, int>> {
  FutureOr<Map<String, int>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<Map<String, int>>, Map<String, int>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Map<String, int>>, Map<String, int>>,
              AsyncValue<Map<String, int>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
