// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'episode_user_status_supabase.model.dart';

class EpisodeUserStatusSupabaseMapper
    extends ClassMapperBase<EpisodeUserStatusSupabase> {
  EpisodeUserStatusSupabaseMapper._();

  static EpisodeUserStatusSupabaseMapper? _instance;
  static EpisodeUserStatusSupabaseMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals
          .use(_instance = EpisodeUserStatusSupabaseMapper._());
      DurationModelMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'EpisodeUserStatusSupabase';

  static String _$userId(EpisodeUserStatusSupabase v) => v.userId;
  static const Field<EpisodeUserStatusSupabase, String> _f$userId =
      Field('userId', _$userId);
  static String _$episodeId(EpisodeUserStatusSupabase v) => v.episodeId;
  static const Field<EpisodeUserStatusSupabase, String> _f$episodeId =
      Field('episodeId', _$episodeId);
  static bool _$listened(EpisodeUserStatusSupabase v) => v.listened;
  static const Field<EpisodeUserStatusSupabase, bool> _f$listened =
      Field('listened', _$listened);
  static DurationModel _$currentPosition(EpisodeUserStatusSupabase v) =>
      v.currentPosition;
  static const Field<EpisodeUserStatusSupabase, DurationModel>
      _f$currentPosition = Field('currentPosition', _$currentPosition);

  @override
  final MappableFields<EpisodeUserStatusSupabase> fields = const {
    #userId: _f$userId,
    #episodeId: _f$episodeId,
    #listened: _f$listened,
    #currentPosition: _f$currentPosition,
  };

  static EpisodeUserStatusSupabase _instantiate(DecodingData data) {
    return EpisodeUserStatusSupabase(
        userId: data.dec(_f$userId),
        episodeId: data.dec(_f$episodeId),
        listened: data.dec(_f$listened),
        currentPosition: data.dec(_f$currentPosition));
  }

  @override
  final Function instantiate = _instantiate;

  static EpisodeUserStatusSupabase fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<EpisodeUserStatusSupabase>(map);
  }

  static EpisodeUserStatusSupabase fromJson(String json) {
    return ensureInitialized().decodeJson<EpisodeUserStatusSupabase>(json);
  }
}

mixin EpisodeUserStatusSupabaseMappable {
  String toJson() {
    return EpisodeUserStatusSupabaseMapper.ensureInitialized()
        .encodeJson<EpisodeUserStatusSupabase>(
            this as EpisodeUserStatusSupabase);
  }

  Map<String, dynamic> toMap() {
    return EpisodeUserStatusSupabaseMapper.ensureInitialized()
        .encodeMap<EpisodeUserStatusSupabase>(
            this as EpisodeUserStatusSupabase);
  }

  EpisodeUserStatusSupabaseCopyWith<EpisodeUserStatusSupabase,
          EpisodeUserStatusSupabase, EpisodeUserStatusSupabase>
      get copyWith => _EpisodeUserStatusSupabaseCopyWithImpl(
          this as EpisodeUserStatusSupabase, $identity, $identity);
  @override
  String toString() {
    return EpisodeUserStatusSupabaseMapper.ensureInitialized()
        .stringifyValue(this as EpisodeUserStatusSupabase);
  }

  @override
  bool operator ==(Object other) {
    return EpisodeUserStatusSupabaseMapper.ensureInitialized()
        .equalsValue(this as EpisodeUserStatusSupabase, other);
  }

  @override
  int get hashCode {
    return EpisodeUserStatusSupabaseMapper.ensureInitialized()
        .hashValue(this as EpisodeUserStatusSupabase);
  }
}

extension EpisodeUserStatusSupabaseValueCopy<$R, $Out>
    on ObjectCopyWith<$R, EpisodeUserStatusSupabase, $Out> {
  EpisodeUserStatusSupabaseCopyWith<$R, EpisodeUserStatusSupabase, $Out>
      get $asEpisodeUserStatusSupabase => $base
          .as((v, t, t2) => _EpisodeUserStatusSupabaseCopyWithImpl(v, t, t2));
}

abstract class EpisodeUserStatusSupabaseCopyWith<
    $R,
    $In extends EpisodeUserStatusSupabase,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  DurationModelCopyWith<$R, DurationModel, DurationModel> get currentPosition;
  $R call(
      {String? userId,
      String? episodeId,
      bool? listened,
      DurationModel? currentPosition});
  EpisodeUserStatusSupabaseCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _EpisodeUserStatusSupabaseCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, EpisodeUserStatusSupabase, $Out>
    implements
        EpisodeUserStatusSupabaseCopyWith<$R, EpisodeUserStatusSupabase, $Out> {
  _EpisodeUserStatusSupabaseCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<EpisodeUserStatusSupabase> $mapper =
      EpisodeUserStatusSupabaseMapper.ensureInitialized();
  @override
  DurationModelCopyWith<$R, DurationModel, DurationModel> get currentPosition =>
      $value.currentPosition.copyWith.$chain((v) => call(currentPosition: v));
  @override
  $R call(
          {String? userId,
          String? episodeId,
          bool? listened,
          DurationModel? currentPosition}) =>
      $apply(FieldCopyWithData({
        if (userId != null) #userId: userId,
        if (episodeId != null) #episodeId: episodeId,
        if (listened != null) #listened: listened,
        if (currentPosition != null) #currentPosition: currentPosition
      }));
  @override
  EpisodeUserStatusSupabase $make(CopyWithData data) =>
      EpisodeUserStatusSupabase(
          userId: data.get(#userId, or: $value.userId),
          episodeId: data.get(#episodeId, or: $value.episodeId),
          listened: data.get(#listened, or: $value.listened),
          currentPosition:
              data.get(#currentPosition, or: $value.currentPosition));

  @override
  EpisodeUserStatusSupabaseCopyWith<$R2, EpisodeUserStatusSupabase, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _EpisodeUserStatusSupabaseCopyWithImpl($value, $cast, t);
}
