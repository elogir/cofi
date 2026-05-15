// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Query)
final queryProvider = QueryProvider._();

final class QueryProvider extends $NotifierProvider<Query, String> {
  QueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'queryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$queryHash();

  @$internal
  @override
  Query create() => Query();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$queryHash() => r'cc04dff3c2b6dadbd9f24653888a2e0828191a99';

abstract class _$Query extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
