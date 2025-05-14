// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'find_podcast_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(FindPodcast)
const findPodcastProvider = FindPodcastProvider._();

final class FindPodcastProvider
    extends $AsyncNotifierProvider<FindPodcast, List<PodcastSearch>> {
  const FindPodcastProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'findPodcastProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$findPodcastHash();

  @$internal
  @override
  FindPodcast create() => FindPodcast();

  @$internal
  @override
  $AsyncNotifierProviderElement<FindPodcast, List<PodcastSearch>>
  $createElement($ProviderPointer pointer) =>
      $AsyncNotifierProviderElement(pointer);
}

String _$findPodcastHash() => r'e4475f029e5a14e7288cda507eb9faee2c404c37';

abstract class _$FindPodcast extends $AsyncNotifier<List<PodcastSearch>> {
  FutureOr<List<PodcastSearch>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<PodcastSearch>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<PodcastSearch>>>,
              AsyncValue<List<PodcastSearch>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
