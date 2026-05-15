// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filtered_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(filteredEntries)
final filteredEntriesProvider = FilteredEntriesProvider._();

final class FilteredEntriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<DesktopEntry>>,
          List<DesktopEntry>,
          FutureOr<List<DesktopEntry>>
        >
    with
        $FutureModifier<List<DesktopEntry>>,
        $FutureProvider<List<DesktopEntry>> {
  FilteredEntriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredEntriesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredEntriesHash();

  @$internal
  @override
  $FutureProviderElement<List<DesktopEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<DesktopEntry>> create(Ref ref) {
    return filteredEntries(ref);
  }
}

String _$filteredEntriesHash() => r'5eccbfc9820c33dfe4f6a97a15f016939f2d5fc0';
