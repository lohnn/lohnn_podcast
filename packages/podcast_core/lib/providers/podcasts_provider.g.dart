// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'podcasts_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$subscribedPodcastHash() => r'ecb0a3c5b886df5f3533ff457f662dfdcf86a3c9';

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

/// See also [subscribedPodcast].
@ProviderFor(subscribedPodcast)
const subscribedPodcastProvider = SubscribedPodcastFamily();

/// See also [subscribedPodcast].
class SubscribedPodcastFamily extends Family<AsyncValue<bool?>> {
  /// See also [subscribedPodcast].
  const SubscribedPodcastFamily();

  /// See also [subscribedPodcast].
  SubscribedPodcastProvider call({required PodcastRssUrl rssUrl}) {
    return SubscribedPodcastProvider(rssUrl: rssUrl);
  }

  @override
  SubscribedPodcastProvider getProviderOverride(
    covariant SubscribedPodcastProvider provider,
  ) {
    return call(rssUrl: provider.rssUrl);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'subscribedPodcastProvider';
}

/// See also [subscribedPodcast].
class SubscribedPodcastProvider extends AutoDisposeFutureProvider<bool?> {
  /// See also [subscribedPodcast].
  SubscribedPodcastProvider({required PodcastRssUrl rssUrl})
    : this._internal(
        (ref) => subscribedPodcast(ref as SubscribedPodcastRef, rssUrl: rssUrl),
        from: subscribedPodcastProvider,
        name: r'subscribedPodcastProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$subscribedPodcastHash,
        dependencies: SubscribedPodcastFamily._dependencies,
        allTransitiveDependencies:
            SubscribedPodcastFamily._allTransitiveDependencies,
        rssUrl: rssUrl,
      );

  SubscribedPodcastProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.rssUrl,
  }) : super.internal();

  final PodcastRssUrl rssUrl;

  @override
  Override overrideWith(
    FutureOr<bool?> Function(SubscribedPodcastRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SubscribedPodcastProvider._internal(
        (ref) => create(ref as SubscribedPodcastRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        rssUrl: rssUrl,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<bool?> createElement() {
    return _SubscribedPodcastProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SubscribedPodcastProvider && other.rssUrl == rssUrl;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, rssUrl.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SubscribedPodcastRef on AutoDisposeFutureProviderRef<bool?> {
  /// The parameter `rssUrl` of this provider.
  PodcastRssUrl get rssUrl;
}

class _SubscribedPodcastProviderElement
    extends AutoDisposeFutureProviderElement<bool?>
    with SubscribedPodcastRef {
  _SubscribedPodcastProviderElement(super.provider);

  @override
  PodcastRssUrl get rssUrl => (origin as SubscribedPodcastProvider).rssUrl;
}

String _$subscribedPodcastRssUrlsHash() =>
    r'0555924743455e102991354daa73b5b68e0ab199';

/// See also [_subscribedPodcastRssUrls].
@ProviderFor(_subscribedPodcastRssUrls)
final _subscribedPodcastRssUrlsProvider =
    AutoDisposeFutureProvider<Iterable<PodcastRssUrl>?>.internal(
      _subscribedPodcastRssUrls,
      name: r'_subscribedPodcastRssUrlsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$subscribedPodcastRssUrlsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef _SubscribedPodcastRssUrlsRef =
    AutoDisposeFutureProviderRef<Iterable<PodcastRssUrl>?>;
String _$podcastPodHash() => r'77f981421c3d7c1a388b2fade47aae2598a341ca';

abstract class _$PodcastPod extends BuildlessAutoDisposeAsyncNotifier<Podcast> {
  late final PodcastId podcastId;

  FutureOr<Podcast> build(PodcastId podcastId);
}

/// See also [PodcastPod].
@ProviderFor(PodcastPod)
const podcastPodProvider = PodcastPodFamily();

/// See also [PodcastPod].
class PodcastPodFamily extends Family<AsyncValue<Podcast>> {
  /// See also [PodcastPod].
  const PodcastPodFamily();

  /// See also [PodcastPod].
  PodcastPodProvider call(PodcastId podcastId) {
    return PodcastPodProvider(podcastId);
  }

  @override
  PodcastPodProvider getProviderOverride(
    covariant PodcastPodProvider provider,
  ) {
    return call(provider.podcastId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'podcastPodProvider';
}

/// See also [PodcastPod].
class PodcastPodProvider
    extends AutoDisposeAsyncNotifierProviderImpl<PodcastPod, Podcast> {
  /// See also [PodcastPod].
  PodcastPodProvider(PodcastId podcastId)
    : this._internal(
        () => PodcastPod()..podcastId = podcastId,
        from: podcastPodProvider,
        name: r'podcastPodProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$podcastPodHash,
        dependencies: PodcastPodFamily._dependencies,
        allTransitiveDependencies: PodcastPodFamily._allTransitiveDependencies,
        podcastId: podcastId,
      );

  PodcastPodProvider._internal(
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
  FutureOr<Podcast> runNotifierBuild(covariant PodcastPod notifier) {
    return notifier.build(podcastId);
  }

  @override
  Override overrideWith(PodcastPod Function() create) {
    return ProviderOverride(
      origin: this,
      override: PodcastPodProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<PodcastPod, Podcast> createElement() {
    return _PodcastPodProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PodcastPodProvider && other.podcastId == podcastId;
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
mixin PodcastPodRef on AutoDisposeAsyncNotifierProviderRef<Podcast> {
  /// The parameter `podcastId` of this provider.
  PodcastId get podcastId;
}

class _PodcastPodProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<PodcastPod, Podcast>
    with PodcastPodRef {
  _PodcastPodProviderElement(super.provider);

  @override
  PodcastId get podcastId => (origin as PodcastPodProvider).podcastId;
}

String _$podcastsHash() => r'5d4410738e357e7c7ad4f9b15fb1e3025dbe6fb3';

/// See also [Podcasts].
@ProviderFor(Podcasts)
final podcastsProvider = AutoDisposeStreamNotifierProvider<
  Podcasts,
  EquatableList<Podcast>
>.internal(
  Podcasts.new,
  name: r'podcastsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$podcastsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Podcasts = AutoDisposeStreamNotifier<EquatableList<Podcast>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
