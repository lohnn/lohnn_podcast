// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'podcasts_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(subscribedPodcast)
const subscribedPodcastProvider = SubscribedPodcastFamily._();

final class SubscribedPodcastProvider
    extends $FunctionalProvider<AsyncValue<bool?>, bool?, FutureOr<bool?>>
    with $FutureModifier<bool?>, $FutureProvider<bool?> {
  const SubscribedPodcastProvider._({
    required SubscribedPodcastFamily super.from,
    required PodcastRssUrl super.argument,
  }) : super(
         retry: null,
         name: r'subscribedPodcastProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$subscribedPodcastHash();

  @override
  String toString() {
    return r'subscribedPodcastProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<bool?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool?> create(Ref ref) {
    final argument = this.argument as PodcastRssUrl;
    return subscribedPodcast(ref, rssUrl: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SubscribedPodcastProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$subscribedPodcastHash() => r'5f80849651ddef8fb949a0704dd6b2fd0b4b2a61';

final class SubscribedPodcastFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<bool?>, PodcastRssUrl> {
  const SubscribedPodcastFamily._()
    : super(
        retry: null,
        name: r'subscribedPodcastProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SubscribedPodcastProvider call({required PodcastRssUrl rssUrl}) =>
      SubscribedPodcastProvider._(argument: rssUrl, from: this);

  @override
  String toString() => r'subscribedPodcastProvider';
}

@ProviderFor(_subscribedPodcastRssUrls)
const _subscribedPodcastRssUrlsProvider = _SubscribedPodcastRssUrlsProvider._();

final class _SubscribedPodcastRssUrlsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Iterable<PodcastRssUrl>?>,
          Iterable<PodcastRssUrl>?,
          FutureOr<Iterable<PodcastRssUrl>?>
        >
    with
        $FutureModifier<Iterable<PodcastRssUrl>?>,
        $FutureProvider<Iterable<PodcastRssUrl>?> {
  const _SubscribedPodcastRssUrlsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'_subscribedPodcastRssUrlsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$subscribedPodcastRssUrlsHash();

  @$internal
  @override
  $FutureProviderElement<Iterable<PodcastRssUrl>?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Iterable<PodcastRssUrl>?> create(Ref ref) {
    return _subscribedPodcastRssUrls(ref);
  }
}

String _$subscribedPodcastRssUrlsHash() =>
    r'5c45b5aa5f10dfdfbcedd7d02ca3b862f90691bc';

@ProviderFor(PodcastPod)
const podcastPodProvider = PodcastPodFamily._();

final class PodcastPodProvider
    extends $AsyncNotifierProvider<PodcastPod, Podcast> {
  const PodcastPodProvider._({
    required PodcastPodFamily super.from,
    required PodcastId super.argument,
  }) : super(
         retry: null,
         name: r'podcastPodProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$podcastPodHash();

  @override
  String toString() {
    return r'podcastPodProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  PodcastPod create() => PodcastPod();

  @override
  bool operator ==(Object other) {
    return other is PodcastPodProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$podcastPodHash() => r'77f981421c3d7c1a388b2fade47aae2598a341ca';

final class PodcastPodFamily extends $Family
    with
        $ClassFamilyOverride<
          PodcastPod,
          AsyncValue<Podcast>,
          Podcast,
          FutureOr<Podcast>,
          PodcastId
        > {
  const PodcastPodFamily._()
    : super(
        retry: null,
        name: r'podcastPodProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PodcastPodProvider call(PodcastId podcastId) =>
      PodcastPodProvider._(argument: podcastId, from: this);

  @override
  String toString() => r'podcastPodProvider';
}

abstract class _$PodcastPod extends $AsyncNotifier<Podcast> {
  late final _$args = ref.$arg as PodcastId;
  PodcastId get podcastId => _$args;

  FutureOr<Podcast> build(PodcastId podcastId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<AsyncValue<Podcast>, Podcast>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Podcast>, Podcast>,
              AsyncValue<Podcast>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(Podcasts)
const podcastsProvider = PodcastsProvider._();

final class PodcastsProvider
    extends $StreamNotifierProvider<Podcasts, EquatableList<Podcast>> {
  const PodcastsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'podcastsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$podcastsHash();

  @$internal
  @override
  Podcasts create() => Podcasts();
}

String _$podcastsHash() => r'5d4410738e357e7c7ad4f9b15fb1e3025dbe6fb3';

abstract class _$Podcasts extends $StreamNotifier<EquatableList<Podcast>> {
  Stream<EquatableList<Podcast>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<AsyncValue<EquatableList<Podcast>>, EquatableList<Podcast>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<EquatableList<Podcast>>,
                EquatableList<Podcast>
              >,
              AsyncValue<EquatableList<Podcast>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
