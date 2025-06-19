// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_episode_status_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(userEpisodeStatus)
const userEpisodeStatusProvider = UserEpisodeStatusFamily._();

final class UserEpisodeStatusProvider
    extends
        $FunctionalProvider<
          AsyncValue<UserEpisodeStatus>,
          FutureOr<UserEpisodeStatus>
        >
    with
        $FutureModifier<UserEpisodeStatus>,
        $FutureProvider<UserEpisodeStatus> {
  const UserEpisodeStatusProvider._({
    required UserEpisodeStatusFamily super.from,
    required EpisodeId super.argument,
  }) : super(
         retry: null,
         name: r'userEpisodeStatusProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$userEpisodeStatusHash();

  @override
  String toString() {
    return r'userEpisodeStatusProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<UserEpisodeStatus> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<UserEpisodeStatus> create(Ref ref) {
    final argument = this.argument as EpisodeId;
    return userEpisodeStatus(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UserEpisodeStatusProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userEpisodeStatusHash() => r'79315401ee83eede4dfadba8defa4caaa97f3348';

final class UserEpisodeStatusFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<UserEpisodeStatus>, EpisodeId> {
  const UserEpisodeStatusFamily._()
    : super(
        retry: null,
        name: r'userEpisodeStatusProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UserEpisodeStatusProvider call(EpisodeId episodeId) =>
      UserEpisodeStatusProvider._(argument: episodeId, from: this);

  @override
  String toString() => r'userEpisodeStatusProvider';
}

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
    r'70931ae31042735390ca7c4eee49d37f77ca1632';

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
