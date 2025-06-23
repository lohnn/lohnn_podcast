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
          PodcastAudioHandler,
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
    r'23325c1f6e7e8c1f8f10c4ede1a5c82491cc4e77';

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
}

String _$audioServicePodHash() => r'166479c7bdc5b280527442922f716103fbf3c856';

abstract class _$AudioServicePod extends $AsyncNotifier<PodcastAudioHandler> {
  FutureOr<PodcastAudioHandler> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<PodcastAudioHandler>, PodcastAudioHandler>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PodcastAudioHandler>, PodcastAudioHandler>,
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
}

String _$audioPlayerPodHash() => r'a1232c701092a307da6771cd2d2afe5cd6ec1c69';

abstract class _$AudioPlayerPod extends $AsyncNotifier<EpisodeWithStatus?> {
  FutureOr<EpisodeWithStatus?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<EpisodeWithStatus?>, EpisodeWithStatus?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<EpisodeWithStatus?>, EpisodeWithStatus?>,
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
          ({Duration position, Duration buffered, Duration? duration}),
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

String _$currentPositionHash() => r'121418eca53c2cdd41fafe65950495adc61300eb';

@ProviderFor(audioState)
const audioStateProvider = AudioStateProvider._();

final class AudioStateProvider
    extends
        $FunctionalProvider<
          AsyncValue<PlaybackState>,
          PlaybackState,
          Stream<PlaybackState>
        >
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

String _$audioStateHash() => r'8f700801439f1fd64e400b937b16182b7ea75bd8';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
