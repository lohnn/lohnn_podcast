// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'episodes_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(EpisodePod)
const episodePodProvider = EpisodePodFamily._();

final class EpisodePodProvider
    extends
        $NotifierProvider<
          EpisodePod,
          AsyncValue<(Podcast, EpisodeWithStatus)>
        > {
  const EpisodePodProvider._({
    required EpisodePodFamily super.from,
    required ({PodcastId podcastId, EpisodeId episodeId}) super.argument,
  }) : super(
         retry: null,
         name: r'episodePodProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$episodePodHash();

  @override
  String toString() {
    return r'episodePodProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  EpisodePod create() => EpisodePod();

  @$internal
  @override
  $NotifierProviderElement<EpisodePod, AsyncValue<(Podcast, EpisodeWithStatus)>>
  $createElement($ProviderPointer pointer) => $NotifierProviderElement(pointer);

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<(Podcast, EpisodeWithStatus)> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $ValueProvider<AsyncValue<(Podcast, EpisodeWithStatus)>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is EpisodePodProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$episodePodHash() => r'b02c69e276b6cbb11048beb9eb29a8d89d930a61';

final class EpisodePodFamily extends $Family
    with
        $ClassFamilyOverride<
          EpisodePod,
          AsyncValue<(Podcast, EpisodeWithStatus)>,
          AsyncValue<(Podcast, EpisodeWithStatus)>,
          AsyncValue<(Podcast, EpisodeWithStatus)>,
          ({PodcastId podcastId, EpisodeId episodeId})
        > {
  const EpisodePodFamily._()
    : super(
        retry: null,
        name: r'episodePodProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  EpisodePodProvider call({
    required PodcastId podcastId,
    required EpisodeId episodeId,
  }) => EpisodePodProvider._(
    argument: (podcastId: podcastId, episodeId: episodeId),
    from: this,
  );

  @override
  String toString() => r'episodePodProvider';
}

abstract class _$EpisodePod
    extends $Notifier<AsyncValue<(Podcast, EpisodeWithStatus)>> {
  late final _$args = ref.$arg as ({PodcastId podcastId, EpisodeId episodeId});
  PodcastId get podcastId => _$args.podcastId;
  EpisodeId get episodeId => _$args.episodeId;

  AsyncValue<(Podcast, EpisodeWithStatus)> build({
    required PodcastId podcastId,
    required EpisodeId episodeId,
  });
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      podcastId: _$args.podcastId,
      episodeId: _$args.episodeId,
    );
    final ref = this.ref as $Ref<AsyncValue<(Podcast, EpisodeWithStatus)>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<(Podcast, EpisodeWithStatus)>>,
              AsyncValue<(Podcast, EpisodeWithStatus)>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(Episodes)
const episodesProvider = EpisodesFamily._();

final class EpisodesProvider
    extends
        $NotifierProvider<
          Episodes,
          AsyncValue<(Podcast, List<EpisodeWithStatus>)>
        > {
  const EpisodesProvider._({
    required EpisodesFamily super.from,
    required PodcastId super.argument,
  }) : super(
         retry: null,
         name: r'episodesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$episodesHash();

  @override
  String toString() {
    return r'episodesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  Episodes create() => Episodes();

  @$internal
  @override
  $NotifierProviderElement<
    Episodes,
    AsyncValue<(Podcast, List<EpisodeWithStatus>)>
  >
  $createElement($ProviderPointer pointer) => $NotifierProviderElement(pointer);

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(
    AsyncValue<(Podcast, List<EpisodeWithStatus>)> value,
  ) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $ValueProvider<AsyncValue<(Podcast, List<EpisodeWithStatus>)>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is EpisodesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$episodesHash() => r'c6b6c9f057336d490ab62c3780ca72d52d330d53';

final class EpisodesFamily extends $Family
    with
        $ClassFamilyOverride<
          Episodes,
          AsyncValue<(Podcast, List<EpisodeWithStatus>)>,
          AsyncValue<(Podcast, List<EpisodeWithStatus>)>,
          AsyncValue<(Podcast, List<EpisodeWithStatus>)>,
          PodcastId
        > {
  const EpisodesFamily._()
    : super(
        retry: null,
        name: r'episodesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  EpisodesProvider call({required PodcastId podcastId}) =>
      EpisodesProvider._(argument: podcastId, from: this);

  @override
  String toString() => r'episodesProvider';
}

abstract class _$Episodes
    extends $Notifier<AsyncValue<(Podcast, List<EpisodeWithStatus>)>> {
  late final _$args = ref.$arg as PodcastId;
  PodcastId get podcastId => _$args;

  AsyncValue<(Podcast, List<EpisodeWithStatus>)> build({
    required PodcastId podcastId,
  });
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(podcastId: _$args);
    final ref =
        this.ref as $Ref<AsyncValue<(Podcast, List<EpisodeWithStatus>)>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<(Podcast, List<EpisodeWithStatus>)>>,
              AsyncValue<(Podcast, List<EpisodeWithStatus>)>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(_episodesImpl)
const _episodesImplProvider = _EpisodesImplFamily._();

final class _EpisodesImplProvider
    extends
        $FunctionalProvider<AsyncValue<List<Episode>>, Stream<List<Episode>>>
    with $FutureModifier<List<Episode>>, $StreamProvider<List<Episode>> {
  const _EpisodesImplProvider._({
    required _EpisodesImplFamily super.from,
    required PodcastId super.argument,
  }) : super(
         retry: null,
         name: r'_episodesImplProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$episodesImplHash();

  @override
  String toString() {
    return r'_episodesImplProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Episode>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Episode>> create(Ref ref) {
    final argument = this.argument as PodcastId;
    return _episodesImpl(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is _EpisodesImplProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$episodesImplHash() => r'cec3aea222607a6c77b62b6b5a2d530a77371897';

final class _EpisodesImplFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Episode>>, PodcastId> {
  const _EpisodesImplFamily._()
    : super(
        retry: null,
        name: r'_episodesImplProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  _EpisodesImplProvider call(PodcastId podcast) =>
      _EpisodesImplProvider._(argument: podcast, from: this);

  @override
  String toString() => r'_episodesImplProvider';
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
