// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'user_episode_status_impl.model.dart';

class UserEpisodeStatusImplMapper
    extends ClassMapperBase<UserEpisodeStatusImpl> {
  UserEpisodeStatusImplMapper._();

  static UserEpisodeStatusImplMapper? _instance;
  static UserEpisodeStatusImplMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UserEpisodeStatusImplMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'UserEpisodeStatusImpl';

  static int _$backingEpisodeId(UserEpisodeStatusImpl v) => v.backingEpisodeId;
  static const Field<UserEpisodeStatusImpl, int> _f$backingEpisodeId =
      Field('backingEpisodeId', _$backingEpisodeId);
  static bool _$isPlayed(UserEpisodeStatusImpl v) => v.isPlayed;
  static const Field<UserEpisodeStatusImpl, bool> _f$isPlayed =
      Field('isPlayed', _$isPlayed);
  static Duration _$currentPosition(UserEpisodeStatusImpl v) =>
      v.currentPosition;
  static const Field<UserEpisodeStatusImpl, Duration> _f$currentPosition =
      Field('currentPosition', _$currentPosition);

  @override
  final MappableFields<UserEpisodeStatusImpl> fields = const {
    #backingEpisodeId: _f$backingEpisodeId,
    #isPlayed: _f$isPlayed,
    #currentPosition: _f$currentPosition,
  };

  static UserEpisodeStatusImpl _instantiate(DecodingData data) {
    return UserEpisodeStatusImpl(
        backingEpisodeId: data.dec(_f$backingEpisodeId),
        isPlayed: data.dec(_f$isPlayed),
        currentPosition: data.dec(_f$currentPosition));
  }

  @override
  final Function instantiate = _instantiate;

  static UserEpisodeStatusImpl fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<UserEpisodeStatusImpl>(map);
  }

  static UserEpisodeStatusImpl fromJson(String json) {
    return ensureInitialized().decodeJson<UserEpisodeStatusImpl>(json);
  }
}

mixin UserEpisodeStatusImplMappable {
  String toJson() {
    return UserEpisodeStatusImplMapper.ensureInitialized()
        .encodeJson<UserEpisodeStatusImpl>(this as UserEpisodeStatusImpl);
  }

  Map<String, dynamic> toMap() {
    return UserEpisodeStatusImplMapper.ensureInitialized()
        .encodeMap<UserEpisodeStatusImpl>(this as UserEpisodeStatusImpl);
  }

  UserEpisodeStatusImplCopyWith<UserEpisodeStatusImpl, UserEpisodeStatusImpl,
      UserEpisodeStatusImpl> get copyWith => _UserEpisodeStatusImplCopyWithImpl<
          UserEpisodeStatusImpl, UserEpisodeStatusImpl>(
      this as UserEpisodeStatusImpl, $identity, $identity);
  @override
  String toString() {
    return UserEpisodeStatusImplMapper.ensureInitialized()
        .stringifyValue(this as UserEpisodeStatusImpl);
  }

  @override
  bool operator ==(Object other) {
    return UserEpisodeStatusImplMapper.ensureInitialized()
        .equalsValue(this as UserEpisodeStatusImpl, other);
  }

  @override
  int get hashCode {
    return UserEpisodeStatusImplMapper.ensureInitialized()
        .hashValue(this as UserEpisodeStatusImpl);
  }
}

extension UserEpisodeStatusImplValueCopy<$R, $Out>
    on ObjectCopyWith<$R, UserEpisodeStatusImpl, $Out> {
  UserEpisodeStatusImplCopyWith<$R, UserEpisodeStatusImpl, $Out>
      get $asUserEpisodeStatusImpl => $base.as(
          (v, t, t2) => _UserEpisodeStatusImplCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class UserEpisodeStatusImplCopyWith<
    $R,
    $In extends UserEpisodeStatusImpl,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call({int? backingEpisodeId, bool? isPlayed, Duration? currentPosition});
  UserEpisodeStatusImplCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _UserEpisodeStatusImplCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, UserEpisodeStatusImpl, $Out>
    implements UserEpisodeStatusImplCopyWith<$R, UserEpisodeStatusImpl, $Out> {
  _UserEpisodeStatusImplCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<UserEpisodeStatusImpl> $mapper =
      UserEpisodeStatusImplMapper.ensureInitialized();
  @override
  $R call({int? backingEpisodeId, bool? isPlayed, Duration? currentPosition}) =>
      $apply(FieldCopyWithData({
        if (backingEpisodeId != null) #backingEpisodeId: backingEpisodeId,
        if (isPlayed != null) #isPlayed: isPlayed,
        if (currentPosition != null) #currentPosition: currentPosition
      }));
  @override
  UserEpisodeStatusImpl $make(CopyWithData data) => UserEpisodeStatusImpl(
      backingEpisodeId:
          data.get(#backingEpisodeId, or: $value.backingEpisodeId),
      isPlayed: data.get(#isPlayed, or: $value.isPlayed),
      currentPosition: data.get(#currentPosition, or: $value.currentPosition));

  @override
  UserEpisodeStatusImplCopyWith<$R2, UserEpisodeStatusImpl, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _UserEpisodeStatusImplCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
