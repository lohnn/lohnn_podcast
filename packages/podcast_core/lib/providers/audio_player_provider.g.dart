// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_player_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$podcastAudioHandlerHash() =>
    r'545ef76ec173df0bc0b5219479c753a0db76cf04';

/// See also [_podcastAudioHandler].
@ProviderFor(_podcastAudioHandler)
final _podcastAudioHandlerProvider =
    FutureProvider<PodcastAudioHandler>.internal(
      _podcastAudioHandler,
      name: r'_podcastAudioHandlerProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$podcastAudioHandlerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef _PodcastAudioHandlerRef = FutureProviderRef<PodcastAudioHandler>;
String _$currentPositionHash() => r'54fa2877ec735ded3e29a57c8269a0d349e41e1b';

/// See also [currentPosition].
@ProviderFor(currentPosition)
final currentPositionProvider = AutoDisposeStreamProvider<
  ({Duration position, Duration buffered, Duration? duration})
>.internal(
  currentPosition,
  name: r'currentPositionProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$currentPositionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentPositionRef =
    AutoDisposeStreamProviderRef<
      ({Duration position, Duration buffered, Duration? duration})
    >;
String _$audioStateHash() => r'1ad26b0abde246b65b7eeb42254e59bde8054739';

/// See also [audioState].
@ProviderFor(audioState)
final audioStateProvider = AutoDisposeStreamProvider<PlaybackState>.internal(
  audioState,
  name: r'audioStateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$audioStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AudioStateRef = AutoDisposeStreamProviderRef<PlaybackState>;
String _$audioServicePodHash() => r'166479c7bdc5b280527442922f716103fbf3c856';

/// See also [_AudioServicePod].
@ProviderFor(_AudioServicePod)
final _audioServicePodProvider =
    AsyncNotifierProvider<_AudioServicePod, PodcastAudioHandler>.internal(
      _AudioServicePod.new,
      name: r'_audioServicePodProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$audioServicePodHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AudioServicePod = AsyncNotifier<PodcastAudioHandler>;
String _$audioPlayerPodHash() => r'c0328c89cba5b8bf3ff94879743788d1d505e7d0';

/// See also [AudioPlayerPod].
@ProviderFor(AudioPlayerPod)
final audioPlayerPodProvider =
    AsyncNotifierProvider<AudioPlayerPod, EpisodeWithStatus?>.internal(
      AudioPlayerPod.new,
      name: r'audioPlayerPodProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$audioPlayerPodHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AudioPlayerPod = AsyncNotifier<EpisodeWithStatus?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
