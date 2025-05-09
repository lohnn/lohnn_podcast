// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'episode_loader_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$episodeLoaderHash() => r'2dbf4f608e0ef43d41b83e3da86423ab545a8c70';

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

abstract class _$EpisodeLoader
    extends BuildlessAutoDisposeAsyncNotifier<EpisodeFileResponse> {
  late final Episode episode;

  FutureOr<EpisodeFileResponse> build(Episode episode);
}

/// See also [EpisodeLoader].
@ProviderFor(EpisodeLoader)
const episodeLoaderProvider = EpisodeLoaderFamily();

/// See also [EpisodeLoader].
class EpisodeLoaderFamily extends Family<AsyncValue<EpisodeFileResponse>> {
  /// See also [EpisodeLoader].
  const EpisodeLoaderFamily();

  /// See also [EpisodeLoader].
  EpisodeLoaderProvider call(Episode episode) {
    return EpisodeLoaderProvider(episode);
  }

  @override
  EpisodeLoaderProvider getProviderOverride(
    covariant EpisodeLoaderProvider provider,
  ) {
    return call(provider.episode);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'episodeLoaderProvider';
}

/// See also [EpisodeLoader].
class EpisodeLoaderProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          EpisodeLoader,
          EpisodeFileResponse
        > {
  /// See also [EpisodeLoader].
  EpisodeLoaderProvider(Episode episode)
    : this._internal(
        () => EpisodeLoader()..episode = episode,
        from: episodeLoaderProvider,
        name: r'episodeLoaderProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$episodeLoaderHash,
        dependencies: EpisodeLoaderFamily._dependencies,
        allTransitiveDependencies:
            EpisodeLoaderFamily._allTransitiveDependencies,
        episode: episode,
      );

  EpisodeLoaderProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.episode,
  }) : super.internal();

  final Episode episode;

  @override
  FutureOr<EpisodeFileResponse> runNotifierBuild(
    covariant EpisodeLoader notifier,
  ) {
    return notifier.build(episode);
  }

  @override
  Override overrideWith(EpisodeLoader Function() create) {
    return ProviderOverride(
      origin: this,
      override: EpisodeLoaderProvider._internal(
        () => create()..episode = episode,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        episode: episode,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<EpisodeLoader, EpisodeFileResponse>
  createElement() {
    return _EpisodeLoaderProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EpisodeLoaderProvider && other.episode == episode;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, episode.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin EpisodeLoaderRef
    on AutoDisposeAsyncNotifierProviderRef<EpisodeFileResponse> {
  /// The parameter `episode` of this provider.
  Episode get episode;
}

class _EpisodeLoaderProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          EpisodeLoader,
          EpisodeFileResponse
        >
    with EpisodeLoaderRef {
  _EpisodeLoaderProviderElement(super.provider);

  @override
  Episode get episode => (origin as EpisodeLoaderProvider).episode;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
