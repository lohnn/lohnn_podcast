// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'episode_user_status.model.dart';

class EpisodeUserStatusMapper extends ClassMapperBase<EpisodeUserStatus> {
  EpisodeUserStatusMapper._();

  static EpisodeUserStatusMapper? _instance;
  static EpisodeUserStatusMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = EpisodeUserStatusMapper._());
      DurationModelMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'EpisodeUserStatus';

  static String _$userId(EpisodeUserStatus v) => v.userId;
  static const Field<EpisodeUserStatus, String> _f$userId = Field(
    'userId',
    _$userId,
  );
  static String _$episodeId(EpisodeUserStatus v) => v.episodeId;
  static const Field<EpisodeUserStatus, String> _f$episodeId = Field(
    'episodeId',
    _$episodeId,
  );
  static bool _$listened(EpisodeUserStatus v) => v.listened;
  static const Field<EpisodeUserStatus, bool> _f$listened = Field(
    'listened',
    _$listened,
  );
  static DurationModel _$currentPosition(EpisodeUserStatus v) =>
      v.currentPosition;
  static const Field<EpisodeUserStatus, DurationModel> _f$currentPosition =
      Field('currentPosition', _$currentPosition);

  @override
  final MappableFields<EpisodeUserStatus> fields = const {
    #userId: _f$userId,
    #episodeId: _f$episodeId,
    #listened: _f$listened,
    #currentPosition: _f$currentPosition,
  };

  static EpisodeUserStatus _instantiate(DecodingData data) {
    return EpisodeUserStatus(
      userId: data.dec(_f$userId),
      episodeId: data.dec(_f$episodeId),
      listened: data.dec(_f$listened),
      currentPosition: data.dec(_f$currentPosition),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static EpisodeUserStatus fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<EpisodeUserStatus>(map);
  }

  static EpisodeUserStatus fromJson(String json) {
    return ensureInitialized().decodeJson<EpisodeUserStatus>(json);
  }
}

mixin EpisodeUserStatusMappable {
  String toJson() {
    return EpisodeUserStatusMapper.ensureInitialized()
        .encodeJson<EpisodeUserStatus>(this as EpisodeUserStatus);
  }

  Map<String, dynamic> toMap() {
    return EpisodeUserStatusMapper.ensureInitialized()
        .encodeMap<EpisodeUserStatus>(this as EpisodeUserStatus);
  }

  EpisodeUserStatusCopyWith<
    EpisodeUserStatus,
    EpisodeUserStatus,
    EpisodeUserStatus
  >
  get copyWith => _EpisodeUserStatusCopyWithImpl(
    this as EpisodeUserStatus,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return EpisodeUserStatusMapper.ensureInitialized().stringifyValue(
      this as EpisodeUserStatus,
    );
  }

  @override
  bool operator ==(Object other) {
    return EpisodeUserStatusMapper.ensureInitialized().equalsValue(
      this as EpisodeUserStatus,
      other,
    );
  }

  @override
  int get hashCode {
    return EpisodeUserStatusMapper.ensureInitialized().hashValue(
      this as EpisodeUserStatus,
    );
  }
}

extension EpisodeUserStatusValueCopy<$R, $Out>
    on ObjectCopyWith<$R, EpisodeUserStatus, $Out> {
  EpisodeUserStatusCopyWith<$R, EpisodeUserStatus, $Out>
  get $asEpisodeUserStatus =>
      $base.as((v, t, t2) => _EpisodeUserStatusCopyWithImpl(v, t, t2));
}

abstract class EpisodeUserStatusCopyWith<
  $R,
  $In extends EpisodeUserStatus,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  DurationModelCopyWith<$R, DurationModel, DurationModel> get currentPosition;
  $R call({
    String? userId,
    String? episodeId,
    bool? listened,
    DurationModel? currentPosition,
  });
  EpisodeUserStatusCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _EpisodeUserStatusCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, EpisodeUserStatus, $Out>
    implements EpisodeUserStatusCopyWith<$R, EpisodeUserStatus, $Out> {
  _EpisodeUserStatusCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<EpisodeUserStatus> $mapper =
      EpisodeUserStatusMapper.ensureInitialized();
  @override
  DurationModelCopyWith<$R, DurationModel, DurationModel> get currentPosition =>
      $value.currentPosition.copyWith.$chain((v) => call(currentPosition: v));
  @override
  $R call({
    String? userId,
    String? episodeId,
    bool? listened,
    DurationModel? currentPosition,
  }) => $apply(
    FieldCopyWithData({
      if (userId != null) #userId: userId,
      if (episodeId != null) #episodeId: episodeId,
      if (listened != null) #listened: listened,
      if (currentPosition != null) #currentPosition: currentPosition,
    }),
  );
  @override
  EpisodeUserStatus $make(CopyWithData data) => EpisodeUserStatus(
    userId: data.get(#userId, or: $value.userId),
    episodeId: data.get(#episodeId, or: $value.episodeId),
    listened: data.get(#listened, or: $value.listened),
    currentPosition: data.get(#currentPosition, or: $value.currentPosition),
  );

  @override
  EpisodeUserStatusCopyWith<$R2, EpisodeUserStatus, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _EpisodeUserStatusCopyWithImpl($value, $cast, t);
}
