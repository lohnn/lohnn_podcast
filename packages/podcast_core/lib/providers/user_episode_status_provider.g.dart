// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_episode_status_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(UserEpisodeStatusPod)
const userEpisodeStatusPodProvider = UserEpisodeStatusPodProvider._();

final class UserEpisodeStatusPodProvider
    extends
        $StreamNotifierProvider<
          UserEpisodeStatusPod,
          EquatableMap<EpisodeId, UserEpisodeStatus>
        > {
  const UserEpisodeStatusPodProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userEpisodeStatusPodProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userEpisodeStatusPodHash();

  @$internal
  @override
  UserEpisodeStatusPod create() => UserEpisodeStatusPod();

  @$internal
  @override
  $StreamNotifierProviderElement<
    UserEpisodeStatusPod,
    EquatableMap<EpisodeId, UserEpisodeStatus>
  >
  $createElement($ProviderPointer pointer) =>
      $StreamNotifierProviderElement(pointer);
}

String _$userEpisodeStatusPodHash() =>
    r'05c45ca93181ed154e690e2979bbdc36ce8e75c1';

abstract class _$UserEpisodeStatusPod
    extends $StreamNotifier<EquatableMap<EpisodeId, UserEpisodeStatus>> {
  Stream<EquatableMap<EpisodeId, UserEpisodeStatus>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<AsyncValue<EquatableMap<EpisodeId, UserEpisodeStatus>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<EquatableMap<EpisodeId, UserEpisodeStatus>>
              >,
              AsyncValue<EquatableMap<EpisodeId, UserEpisodeStatus>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
