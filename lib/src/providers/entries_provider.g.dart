// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entries_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(desktopEntries)
final desktopEntriesProvider = DesktopEntriesProvider._();

final class DesktopEntriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<DesktopEntry>>,
          List<DesktopEntry>,
          FutureOr<List<DesktopEntry>>
        >
    with
        $FutureModifier<List<DesktopEntry>>,
        $FutureProvider<List<DesktopEntry>> {
  DesktopEntriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'desktopEntriesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$desktopEntriesHash();

  @$internal
  @override
  $FutureProviderElement<List<DesktopEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<DesktopEntry>> create(Ref ref) {
    return desktopEntries(ref);
  }
}

String _$desktopEntriesHash() => r'40bceeda969a0dd183ece8245c0ffd7f8e68626a';
