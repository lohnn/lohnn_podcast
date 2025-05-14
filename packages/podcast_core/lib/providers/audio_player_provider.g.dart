// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_player_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(_podcastAudioHandler)
const _podcastAudioHandlerProvider = _PodcastAudioHandlerProvider._();

final class _PodcastAudioHandlerProvider
    extends
        $FunctionalProvider<
          AsyncValue<PodcastAudioHandler>,
          FutureOr<PodcastAudioHandler>
        >
    with
        $FutureModifier<PodcastAudioHandler>,
        $FutureProvider<PodcastAudioHandler> {
  const _PodcastAudioHandlerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'_podcastAudioHandlerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$podcastAudioHandlerHash();

  @$internal
  @override
  $FutureProviderElement<PodcastAudioHandler> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PodcastAudioHandler> create(Ref ref) {
    return _podcastAudioHandler(ref);
  }
}

String _$podcastAudioHandlerHash() =>
    r'545ef76ec173df0bc0b5219479c753a0db76cf04';

@ProviderFor(_AudioServicePod)
const _audioServicePodProvider = _AudioServicePodProvider._();

final class _AudioServicePodProvider
    extends $AsyncNotifierProvider<_AudioServicePod, PodcastAudioHandler> {
  const _AudioServicePodProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'_audioServicePodProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$audioServicePodHash();

  @$internal
  @override
  _AudioServicePod create() => _AudioServicePod();

  @$internal
  @override
  $AsyncNotifierProviderElement<_AudioServicePod, PodcastAudioHandler>
  $createElement($ProviderPointer pointer) =>
      $AsyncNotifierProviderElement(pointer);
}

String _$audioServicePodHash() => r'166479c7bdc5b280527442922f716103fbf3c856';

abstract class _$AudioServicePod extends $AsyncNotifier<PodcastAudioHandler> {
  FutureOr<PodcastAudioHandler> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<PodcastAudioHandler>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PodcastAudioHandler>>,
              AsyncValue<PodcastAudioHandler>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(AudioPlayerPod)
const audioPlayerPodProvider = AudioPlayerPodProvider._();

final class AudioPlayerPodProvider
    extends $AsyncNotifierProvider<AudioPlayerPod, EpisodeWithStatus?> {
  const AudioPlayerPodProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'audioPlayerPodProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$audioPlayerPodHash();

  @$internal
  @override
  AudioPlayerPod create() => AudioPlayerPod();

  @$internal
  @override
  $AsyncNotifierProviderElement<AudioPlayerPod, EpisodeWithStatus?>
  $createElement($ProviderPointer pointer) =>
      $AsyncNotifierProviderElement(pointer);
}

String _$audioPlayerPodHash() => r'c0328c89cba5b8bf3ff94879743788d1d505e7d0';

abstract class _$AudioPlayerPod extends $AsyncNotifier<EpisodeWithStatus?> {
  FutureOr<EpisodeWithStatus?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<EpisodeWithStatus?>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<EpisodeWithStatus?>>,
              AsyncValue<EpisodeWithStatus?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(currentPosition)
const currentPositionProvider = CurrentPositionProvider._();

final class CurrentPositionProvider
    extends
        $FunctionalProvider<
          AsyncValue<
            ({Duration position, Duration buffered, Duration? duration})
          >,
          Stream<({Duration position, Duration buffered, Duration? duration})>
        >
    with
        $FutureModifier<
          ({Duration position, Duration buffered, Duration? duration})
        >,
        $StreamProvider<
          ({Duration position, Duration buffered, Duration? duration})
        > {
  const CurrentPositionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentPositionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentPositionHash();

  @$internal
  @override
  $StreamProviderElement<
    ({Duration position, Duration buffered, Duration? duration})
  >
  $createElement($ProviderPointer pointer) => $StreamProviderElement(pointer);

  @override
  Stream<({Duration position, Duration buffered, Duration? duration})> create(
    Ref ref,
  ) {
    return currentPosition(ref);
  }
}

String _$currentPositionHash() => r'54fa2877ec735ded3e29a57c8269a0d349e41e1b';

@ProviderFor(audioState)
const audioStateProvider = AudioStateProvider._();

final class AudioStateProvider
    extends
        $FunctionalProvider<AsyncValue<PlaybackState>, Stream<PlaybackState>>
    with $FutureModifier<PlaybackState>, $StreamProvider<PlaybackState> {
  const AudioStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'audioStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$audioStateHash();

  @$internal
  @override
  $StreamProviderElement<PlaybackState> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<PlaybackState> create(Ref ref) {
    return audioState(ref);
  }
}

String _$audioStateHash() => r'1ad26b0abde246b65b7eeb42254e59bde8054739';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
