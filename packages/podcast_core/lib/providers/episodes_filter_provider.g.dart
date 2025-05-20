// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'episodes_filter_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(EpisodesFilter)
const episodesFilterProvider = EpisodesFilterProvider._();

final class EpisodesFilterProvider
    extends $NotifierProvider<EpisodesFilter, EpisodesFilterState> {
  const EpisodesFilterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'episodesFilterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$episodesFilterHash();

  @$internal
  @override
  EpisodesFilter create() => EpisodesFilter();

  @$internal
  @override
  $NotifierProviderElement<EpisodesFilter, EpisodesFilterState> $createElement(
    $ProviderPointer pointer,
  ) => $NotifierProviderElement(pointer);

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EpisodesFilterState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<EpisodesFilterState>(value),
    );
  }
}

String _$episodesFilterHash() => r'65e59f9a63535544fe63bbe5d51b1f06feaeb9e4';

abstract class _$EpisodesFilter extends $Notifier<EpisodesFilterState> {
  EpisodesFilterState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<EpisodesFilterState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<EpisodesFilterState>,
              EpisodesFilterState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
