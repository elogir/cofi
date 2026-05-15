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

String _$filteredEntriesHash() => r'768d42f43b7260f0c7149baf9550f0d125febd7d';
