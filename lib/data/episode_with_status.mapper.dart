// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'episode_with_status.dart';

class EpisodeWithStatusMapper extends ClassMapperBase<EpisodeWithStatus> {
  EpisodeWithStatusMapper._();

  static EpisodeWithStatusMapper? _instance;
  static EpisodeWithStatusMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = EpisodeWithStatusMapper._());
      EpisodeSupabaseMapper.ensureInitialized();
      UserEpisodeStatusMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'EpisodeWithStatus';

  static EpisodeSupabase _$episode(EpisodeWithStatus v) => v.episode;
  static const Field<EpisodeWithStatus, EpisodeSupabase> _f$episode =
      Field('episode', _$episode);
  static UserEpisodeStatus? _$status(EpisodeWithStatus v) => v.status;
  static const Field<EpisodeWithStatus, UserEpisodeStatus> _f$status =
      Field('status', _$status, opt: true);

  @override
  final MappableFields<EpisodeWithStatus> fields = const {
    #episode: _f$episode,
    #status: _f$status,
  };

  static EpisodeWithStatus _instantiate(DecodingData data) {
    return EpisodeWithStatus(
        episode: data.dec(_f$episode), status: data.dec(_f$status));
  }

  @override
  final Function instantiate = _instantiate;

  static EpisodeWithStatus fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<EpisodeWithStatus>(map);
  }

  static EpisodeWithStatus fromJson(String json) {
    return ensureInitialized().decodeJson<EpisodeWithStatus>(json);
  }
}

mixin EpisodeWithStatusMappable {
  String toJson() {
    return EpisodeWithStatusMapper.ensureInitialized()
        .encodeJson<EpisodeWithStatus>(this as EpisodeWithStatus);
  }

  Map<String, dynamic> toMap() {
    return EpisodeWithStatusMapper.ensureInitialized()
        .encodeMap<EpisodeWithStatus>(this as EpisodeWithStatus);
  }

  EpisodeWithStatusCopyWith<EpisodeWithStatus, EpisodeWithStatus,
          EpisodeWithStatus>
      get copyWith => _EpisodeWithStatusCopyWithImpl(
          this as EpisodeWithStatus, $identity, $identity);
  @override
  String toString() {
    return EpisodeWithStatusMapper.ensureInitialized()
        .stringifyValue(this as EpisodeWithStatus);
  }

  @override
  bool operator ==(Object other) {
    return EpisodeWithStatusMapper.ensureInitialized()
        .equalsValue(this as EpisodeWithStatus, other);
  }

  @override
  int get hashCode {
    return EpisodeWithStatusMapper.ensureInitialized()
        .hashValue(this as EpisodeWithStatus);
  }
}

extension EpisodeWithStatusValueCopy<$R, $Out>
    on ObjectCopyWith<$R, EpisodeWithStatus, $Out> {
  EpisodeWithStatusCopyWith<$R, EpisodeWithStatus, $Out>
      get $asEpisodeWithStatus =>
          $base.as((v, t, t2) => _EpisodeWithStatusCopyWithImpl(v, t, t2));
}

abstract class EpisodeWithStatusCopyWith<$R, $In extends EpisodeWithStatus,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  EpisodeSupabaseCopyWith<$R, EpisodeSupabase, EpisodeSupabase> get episode;
  UserEpisodeStatusCopyWith<$R, UserEpisodeStatus, UserEpisodeStatus>?
      get status;
  $R call({EpisodeSupabase? episode, UserEpisodeStatus? status});
  EpisodeWithStatusCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _EpisodeWithStatusCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, EpisodeWithStatus, $Out>
    implements EpisodeWithStatusCopyWith<$R, EpisodeWithStatus, $Out> {
  _EpisodeWithStatusCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<EpisodeWithStatus> $mapper =
      EpisodeWithStatusMapper.ensureInitialized();
  @override
  EpisodeSupabaseCopyWith<$R, EpisodeSupabase, EpisodeSupabase> get episode =>
      $value.episode.copyWith.$chain((v) => call(episode: v));
  @override
  UserEpisodeStatusCopyWith<$R, UserEpisodeStatus, UserEpisodeStatus>?
      get status => $value.status?.copyWith.$chain((v) => call(status: v));
  @override
  $R call({EpisodeSupabase? episode, Object? status = $none}) =>
      $apply(FieldCopyWithData({
        if (episode != null) #episode: episode,
        if (status != $none) #status: status
      }));
  @override
  EpisodeWithStatus $make(CopyWithData data) => EpisodeWithStatus(
      episode: data.get(#episode, or: $value.episode),
      status: data.get(#status, or: $value.status));

  @override
  EpisodeWithStatusCopyWith<$R2, EpisodeWithStatus, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _EpisodeWithStatusCopyWithImpl($value, $cast, t);
}
