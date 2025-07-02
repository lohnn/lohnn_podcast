// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist_pod_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(PlaylistPod)
const playlistPodProvider = PlaylistPodProvider._();

final class PlaylistPodProvider
    extends $StreamNotifierProvider<PlaylistPod, List<Episode>> {
  const PlaylistPodProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'playlistPodProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$playlistPodHash();

  @$internal
  @override
  PlaylistPod create() => PlaylistPod();
}

String _$playlistPodHash() => r'6587fd69f7617330f9eb2fef6381dc1fe579ec97';

abstract class _$PlaylistPod extends $StreamNotifier<List<Episode>> {
  Stream<List<Episode>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Episode>>, List<Episode>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Episode>>, List<Episode>>,
              AsyncValue<List<Episode>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
