// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'user_episode_status.model.dart';

class UserEpisodeStatusMapper extends ClassMapperBase<UserEpisodeStatus> {
  UserEpisodeStatusMapper._();

  static UserEpisodeStatusMapper? _instance;
  static UserEpisodeStatusMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UserEpisodeStatusMapper._());
      DurationModelMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'UserEpisodeStatus';

  static String _$episodeId(UserEpisodeStatus v) => v.episodeId;
  static const Field<UserEpisodeStatus, String> _f$episodeId =
      Field('episodeId', _$episodeId);
  static String _$userId(UserEpisodeStatus v) => v.userId;
  static const Field<UserEpisodeStatus, String> _f$userId =
      Field('userId', _$userId);
  static bool _$isPlayed(UserEpisodeStatus v) => v.isPlayed;
  static const Field<UserEpisodeStatus, bool> _f$isPlayed =
      Field('isPlayed', _$isPlayed);
  static DurationModel _$currentPosition(UserEpisodeStatus v) =>
      v.currentPosition;
  static const Field<UserEpisodeStatus, DurationModel> _f$currentPosition =
      Field('currentPosition', _$currentPosition);

  @override
  final MappableFields<UserEpisodeStatus> fields = const {
    #episodeId: _f$episodeId,
    #userId: _f$userId,
    #isPlayed: _f$isPlayed,
    #currentPosition: _f$currentPosition,
  };

  static UserEpisodeStatus _instantiate(DecodingData data) {
    return UserEpisodeStatus(
        episodeId: data.dec(_f$episodeId),
        userId: data.dec(_f$userId),
        isPlayed: data.dec(_f$isPlayed),
        currentPosition: data.dec(_f$currentPosition));
  }

  @override
  final Function instantiate = _instantiate;

  static UserEpisodeStatus fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<UserEpisodeStatus>(map);
  }

  static UserEpisodeStatus fromJson(String json) {
    return ensureInitialized().decodeJson<UserEpisodeStatus>(json);
  }
}

mixin UserEpisodeStatusMappable {
  String toJson() {
    return UserEpisodeStatusMapper.ensureInitialized()
        .encodeJson<UserEpisodeStatus>(this as UserEpisodeStatus);
  }

  Map<String, dynamic> toMap() {
    return UserEpisodeStatusMapper.ensureInitialized()
        .encodeMap<UserEpisodeStatus>(this as UserEpisodeStatus);
  }

  UserEpisodeStatusCopyWith<UserEpisodeStatus, UserEpisodeStatus,
          UserEpisodeStatus>
      get copyWith => _UserEpisodeStatusCopyWithImpl(
          this as UserEpisodeStatus, $identity, $identity);
  @override
  String toString() {
    return UserEpisodeStatusMapper.ensureInitialized()
        .stringifyValue(this as UserEpisodeStatus);
  }

  @override
  bool operator ==(Object other) {
    return UserEpisodeStatusMapper.ensureInitialized()
        .equalsValue(this as UserEpisodeStatus, other);
  }

  @override
  int get hashCode {
    return UserEpisodeStatusMapper.ensureInitialized()
        .hashValue(this as UserEpisodeStatus);
  }
}

extension UserEpisodeStatusValueCopy<$R, $Out>
    on ObjectCopyWith<$R, UserEpisodeStatus, $Out> {
  UserEpisodeStatusCopyWith<$R, UserEpisodeStatus, $Out>
      get $asUserEpisodeStatus =>
          $base.as((v, t, t2) => _UserEpisodeStatusCopyWithImpl(v, t, t2));
}

abstract class UserEpisodeStatusCopyWith<$R, $In extends UserEpisodeStatus,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  DurationModelCopyWith<$R, DurationModel, DurationModel> get currentPosition;
  $R call(
      {String? episodeId,
      String? userId,
      bool? isPlayed,
      DurationModel? currentPosition});
  UserEpisodeStatusCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _UserEpisodeStatusCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, UserEpisodeStatus, $Out>
    implements UserEpisodeStatusCopyWith<$R, UserEpisodeStatus, $Out> {
  _UserEpisodeStatusCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<UserEpisodeStatus> $mapper =
      UserEpisodeStatusMapper.ensureInitialized();
  @override
  DurationModelCopyWith<$R, DurationModel, DurationModel> get currentPosition =>
      $value.currentPosition.copyWith.$chain((v) => call(currentPosition: v));
  @override
  $R call(
          {String? episodeId,
          String? userId,
          bool? isPlayed,
          DurationModel? currentPosition}) =>
      $apply(FieldCopyWithData({
        if (episodeId != null) #episodeId: episodeId,
        if (userId != null) #userId: userId,
        if (isPlayed != null) #isPlayed: isPlayed,
        if (currentPosition != null) #currentPosition: currentPosition
      }));
  @override
  UserEpisodeStatus $make(CopyWithData data) => UserEpisodeStatus(
      episodeId: data.get(#episodeId, or: $value.episodeId),
      userId: data.get(#userId, or: $value.userId),
      isPlayed: data.get(#isPlayed, or: $value.isPlayed),
      currentPosition: data.get(#currentPosition, or: $value.currentPosition));

  @override
  UserEpisodeStatusCopyWith<$R2, UserEpisodeStatus, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _UserEpisodeStatusCopyWithImpl($value, $cast, t);
}
