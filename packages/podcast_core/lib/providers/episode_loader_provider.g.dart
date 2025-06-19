// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'episode_loader_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(EpisodeLoader)
const episodeLoaderProvider = EpisodeLoaderFamily._();

final class EpisodeLoaderProvider
    extends $AsyncNotifierProvider<EpisodeLoader, EpisodeFileResponse> {
  const EpisodeLoaderProvider._({
    required EpisodeLoaderFamily super.from,
    required Episode super.argument,
  }) : super(
         retry: null,
         name: r'episodeLoaderProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$episodeLoaderHash();

  @override
  String toString() {
    return r'episodeLoaderProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  EpisodeLoader create() => EpisodeLoader();

  @$internal
  @override
  $AsyncNotifierProviderElement<EpisodeLoader, EpisodeFileResponse>
  $createElement($ProviderPointer pointer) =>
      $AsyncNotifierProviderElement(pointer);

  @override
  bool operator ==(Object other) {
    return other is EpisodeLoaderProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$episodeLoaderHash() => r'3bb058e6532c55469a37436ebb5bca4558bbf6bc';

final class EpisodeLoaderFamily extends $Family
    with
        $ClassFamilyOverride<
          EpisodeLoader,
          AsyncValue<EpisodeFileResponse>,
          EpisodeFileResponse,
          FutureOr<EpisodeFileResponse>,
          Episode
        > {
  const EpisodeLoaderFamily._()
    : super(
        retry: null,
        name: r'episodeLoaderProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  EpisodeLoaderProvider call(Episode episode) =>
      EpisodeLoaderProvider._(argument: episode, from: this);

  @override
  String toString() => r'episodeLoaderProvider';
}

abstract class _$EpisodeLoader extends $AsyncNotifier<EpisodeFileResponse> {
  late final _$args = ref.$arg as Episode;
  Episode get episode => _$args;

  FutureOr<EpisodeFileResponse> build(Episode episode);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<AsyncValue<EpisodeFileResponse>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<EpisodeFileResponse>>,
              AsyncValue<EpisodeFileResponse>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
