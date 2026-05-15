// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'icon_resolver_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(iconResolver)
final iconResolverProvider = IconResolverProvider._();

final class IconResolverProvider
    extends
        $FunctionalProvider<
          AsyncValue<IconResolver>,
          IconResolver,
          FutureOr<IconResolver>
        >
    with $FutureModifier<IconResolver>, $FutureProvider<IconResolver> {
  IconResolverProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'iconResolverProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$iconResolverHash();

  @$internal
  @override
  $FutureProviderElement<IconResolver> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<IconResolver> create(Ref ref) {
    return iconResolver(ref);
  }
}

String _$iconResolverHash() => r'b41c7a40eb59a626cdd6ce847bc54f7470829f8c';
