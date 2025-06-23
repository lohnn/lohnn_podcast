// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'podcasts_with_status_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(PodcastsWithStatus)
const podcastsWithStatusProvider = PodcastsWithStatusProvider._();

final class PodcastsWithStatusProvider
    extends
        $AsyncNotifierProvider<
          PodcastsWithStatus,
          EquatableList<PodcastWithStatus>
        > {
  const PodcastsWithStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'podcastsWithStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$podcastsWithStatusHash();

  @$internal
  @override
  PodcastsWithStatus create() => PodcastsWithStatus();
}

String _$podcastsWithStatusHash() =>
    r'8093847d9c9165b1c45eb0607fb4de2b9cabccfa';

abstract class _$PodcastsWithStatus
    extends $AsyncNotifier<EquatableList<PodcastWithStatus>> {
  FutureOr<EquatableList<PodcastWithStatus>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<EquatableList<PodcastWithStatus>>,
              EquatableList<PodcastWithStatus>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<EquatableList<PodcastWithStatus>>,
                EquatableList<PodcastWithStatus>
              >,
              AsyncValue<EquatableList<PodcastWithStatus>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
