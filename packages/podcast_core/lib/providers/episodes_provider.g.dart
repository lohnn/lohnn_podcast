// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'episodes_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$episodesImplHash() => r'cec3aea222607a6c77b62b6b5a2d530a77371897';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [_episodesImpl].
@ProviderFor(_episodesImpl)
const _episodesImplProvider = _EpisodesImplFamily();

/// See also [_episodesImpl].
class _EpisodesImplFamily extends Family<AsyncValue<List<Episode>>> {
  /// See also [_episodesImpl].
  const _EpisodesImplFamily();

  /// See also [_episodesImpl].
  _EpisodesImplProvider call(PodcastId podcast) {
    return _EpisodesImplProvider(podcast);
  }

  @override
  _EpisodesImplProvider getProviderOverride(
    covariant _EpisodesImplProvider provider,
  ) {
    return call(provider.podcast);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'_episodesImplProvider';
}

/// See also [_episodesImpl].
class _EpisodesImplProvider extends AutoDisposeStreamProvider<List<Episode>> {
  /// See also [_episodesImpl].
  _EpisodesImplProvider(PodcastId podcast)
    : this._internal(
        (ref) => _episodesImpl(ref as _EpisodesImplRef, podcast),
        from: _episodesImplProvider,
        name: r'_episodesImplProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$episodesImplHash,
        dependencies: _EpisodesImplFamily._dependencies,
        allTransitiveDependencies:
            _EpisodesImplFamily._allTransitiveDependencies,
        podcast: podcast,
      );

  _EpisodesImplProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.podcast,
  }) : super.internal();

  final PodcastId podcast;

  @override
  Override overrideWith(
    Stream<List<Episode>> Function(_EpisodesImplRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: _EpisodesImplProvider._internal(
        (ref) => create(ref as _EpisodesImplRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        podcast: podcast,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Episode>> createElement() {
    return _EpisodesImplProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is _EpisodesImplProvider && other.podcast == podcast;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, podcast.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin _EpisodesImplRef on AutoDisposeStreamProviderRef<List<Episode>> {
  /// The parameter `podcast` of this provider.
  PodcastId get podcast;
}

class _EpisodesImplProviderElement
    extends AutoDisposeStreamProviderElement<List<Episode>>
    with _EpisodesImplRef {
  _EpisodesImplProviderElement(super.provider);

  @override
  PodcastId get podcast => (origin as _EpisodesImplProvider).podcast;
}

String _$episodePodHash() => r'b02c69e276b6cbb11048beb9eb29a8d89d930a61';

abstract class _$EpisodePod
    extends
        BuildlessAutoDisposeNotifier<AsyncValue<(Podcast, EpisodeWithStatus)>> {
  late final PodcastId podcastId;
  late final EpisodeId episodeId;

  AsyncValue<(Podcast, EpisodeWithStatus)> build({
    required PodcastId podcastId,
    required EpisodeId episodeId,
  });
}

/// See also [EpisodePod].
@ProviderFor(EpisodePod)
const episodePodProvider = EpisodePodFamily();

/// See also [EpisodePod].
class EpisodePodFamily
    extends Family<AsyncValue<(Podcast, EpisodeWithStatus)>> {
  /// See also [EpisodePod].
  const EpisodePodFamily();

  /// See also [EpisodePod].
  EpisodePodProvider call({
    required PodcastId podcastId,
    required EpisodeId episodeId,
  }) {
    return EpisodePodProvider(podcastId: podcastId, episodeId: episodeId);
  }

  @override
  EpisodePodProvider getProviderOverride(
    covariant EpisodePodProvider provider,
  ) {
    return call(podcastId: provider.podcastId, episodeId: provider.episodeId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'episodePodProvider';
}

/// See also [EpisodePod].
class EpisodePodProvider
    extends
        AutoDisposeNotifierProviderImpl<
          EpisodePod,
          AsyncValue<(Podcast, EpisodeWithStatus)>
        > {
  /// See also [EpisodePod].
  EpisodePodProvider({
    required PodcastId podcastId,
    required EpisodeId episodeId,
  }) : this._internal(
         () =>
             EpisodePod()
               ..podcastId = podcastId
               ..episodeId = episodeId,
         from: episodePodProvider,
         name: r'episodePodProvider',
         debugGetCreateSourceHash:
             const bool.fromEnvironment('dart.vm.product')
                 ? null
                 : _$episodePodHash,
         dependencies: EpisodePodFamily._dependencies,
         allTransitiveDependencies: EpisodePodFamily._allTransitiveDependencies,
         podcastId: podcastId,
         episodeId: episodeId,
       );

  EpisodePodProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.podcastId,
    required this.episodeId,
  }) : super.internal();

  final PodcastId podcastId;
  final EpisodeId episodeId;

  @override
  AsyncValue<(Podcast, EpisodeWithStatus)> runNotifierBuild(
    covariant EpisodePod notifier,
  ) {
    return notifier.build(podcastId: podcastId, episodeId: episodeId);
  }

  @override
  Override overrideWith(EpisodePod Function() create) {
    return ProviderOverride(
      origin: this,
      override: EpisodePodProvider._internal(
        () =>
            create()
              ..podcastId = podcastId
              ..episodeId = episodeId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        podcastId: podcastId,
        episodeId: episodeId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<
    EpisodePod,
    AsyncValue<(Podcast, EpisodeWithStatus)>
  >
  createElement() {
    return _EpisodePodProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EpisodePodProvider &&
        other.podcastId == podcastId &&
        other.episodeId == episodeId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, podcastId.hashCode);
    hash = _SystemHash.combine(hash, episodeId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin EpisodePodRef
    on
        AutoDisposeNotifierProviderRef<
          AsyncValue<(Podcast, EpisodeWithStatus)>
        > {
  /// The parameter `podcastId` of this provider.
  PodcastId get podcastId;

  /// The parameter `episodeId` of this provider.
  EpisodeId get episodeId;
}

class _EpisodePodProviderElement
    extends
        AutoDisposeNotifierProviderElement<
          EpisodePod,
          AsyncValue<(Podcast, EpisodeWithStatus)>
        >
    with EpisodePodRef {
  _EpisodePodProviderElement(super.provider);

  @override
  PodcastId get podcastId => (origin as EpisodePodProvider).podcastId;
  @override
  EpisodeId get episodeId => (origin as EpisodePodProvider).episodeId;
}

String _$episodesHash() => r'c6b6c9f057336d490ab62c3780ca72d52d330d53';

abstract class _$Episodes
    extends
        BuildlessAutoDisposeNotifier<
          AsyncValue<(Podcast, List<EpisodeWithStatus>)>
        > {
  late final PodcastId podcastId;

  AsyncValue<(Podcast, List<EpisodeWithStatus>)> build({
    required PodcastId podcastId,
  });
}

/// See also [Episodes].
@ProviderFor(Episodes)
const episodesProvider = EpisodesFamily();

/// See also [Episodes].
class EpisodesFamily
    extends Family<AsyncValue<(Podcast, List<EpisodeWithStatus>)>> {
  /// See also [Episodes].
  const EpisodesFamily();

  /// See also [Episodes].
  EpisodesProvider call({required PodcastId podcastId}) {
    return EpisodesProvider(podcastId: podcastId);
  }

  @override
  EpisodesProvider getProviderOverride(covariant EpisodesProvider provider) {
    return call(podcastId: provider.podcastId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'episodesProvider';
}

/// See also [Episodes].
class EpisodesProvider
    extends
        AutoDisposeNotifierProviderImpl<
          Episodes,
          AsyncValue<(Podcast, List<EpisodeWithStatus>)>
        > {
  /// See also [Episodes].
  EpisodesProvider({required PodcastId podcastId})
    : this._internal(
        () => Episodes()..podcastId = podcastId,
        from: episodesProvider,
        name: r'episodesProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$episodesHash,
        dependencies: EpisodesFamily._dependencies,
        allTransitiveDependencies: EpisodesFamily._allTransitiveDependencies,
        podcastId: podcastId,
      );

  EpisodesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.podcastId,
  }) : super.internal();

  final PodcastId podcastId;

  @override
  AsyncValue<(Podcast, List<EpisodeWithStatus>)> runNotifierBuild(
    covariant Episodes notifier,
  ) {
    return notifier.build(podcastId: podcastId);
  }

  @override
  Override overrideWith(Episodes Function() create) {
    return ProviderOverride(
      origin: this,
      override: EpisodesProvider._internal(
        () => create()..podcastId = podcastId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        podcastId: podcastId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<
    Episodes,
    AsyncValue<(Podcast, List<EpisodeWithStatus>)>
  >
  createElement() {
    return _EpisodesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EpisodesProvider && other.podcastId == podcastId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, podcastId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin EpisodesRef
    on
        AutoDisposeNotifierProviderRef<
          AsyncValue<(Podcast, List<EpisodeWithStatus>)>
        > {
  /// The parameter `podcastId` of this provider.
  PodcastId get podcastId;
}

class _EpisodesProviderElement
    extends
        AutoDisposeNotifierProviderElement<
          Episodes,
          AsyncValue<(Podcast, List<EpisodeWithStatus>)>
        >
    with EpisodesRef {
  _EpisodesProviderElement(super.provider);

  @override
  PodcastId get podcastId => (origin as EpisodesProvider).podcastId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
