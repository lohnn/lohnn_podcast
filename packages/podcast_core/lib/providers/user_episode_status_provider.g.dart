// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_episode_status_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userEpisodeStatusPodHash() =>
    r'05c45ca93181ed154e690e2979bbdc36ce8e75c1';

/// See also [UserEpisodeStatusPod].
@ProviderFor(UserEpisodeStatusPod)
final userEpisodeStatusPodProvider = AutoDisposeStreamNotifierProvider<
  UserEpisodeStatusPod,
  EquatableMap<EpisodeId, UserEpisodeStatus>
>.internal(
  UserEpisodeStatusPod.new,
  name: r'userEpisodeStatusPodProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$userEpisodeStatusPodHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$UserEpisodeStatusPod =
    AutoDisposeStreamNotifier<EquatableMap<EpisodeId, UserEpisodeStatus>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
