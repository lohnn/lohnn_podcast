// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'duration_model.dart';

class DurationModelMapper extends ClassMapperBase<DurationModel> {
  DurationModelMapper._();

  static DurationModelMapper? _instance;
  static DurationModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DurationModelMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'DurationModel';

  static Duration _$duration(DurationModel v) => v.duration;
  static const Field<DurationModel, Duration> _f$duration =
      Field('duration', _$duration);

  @override
  final MappableFields<DurationModel> fields = const {
    #duration: _f$duration,
  };

  static DurationModel _instantiate(DecodingData data) {
    return DurationModel(data.dec(_f$duration));
  }

  @override
  final Function instantiate = _instantiate;

  static DurationModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DurationModel>(map);
  }

  static DurationModel fromJson(String json) {
    return ensureInitialized().decodeJson<DurationModel>(json);
  }
}

mixin DurationModelMappable {
  String toJson() {
    return DurationModelMapper.ensureInitialized()
        .encodeJson<DurationModel>(this as DurationModel);
  }

  Map<String, dynamic> toMap() {
    return DurationModelMapper.ensureInitialized()
        .encodeMap<DurationModel>(this as DurationModel);
  }

  DurationModelCopyWith<DurationModel, DurationModel, DurationModel>
      get copyWith => _DurationModelCopyWithImpl(
          this as DurationModel, $identity, $identity);
  @override
  String toString() {
    return DurationModelMapper.ensureInitialized()
        .stringifyValue(this as DurationModel);
  }

  @override
  bool operator ==(Object other) {
    return DurationModelMapper.ensureInitialized()
        .equalsValue(this as DurationModel, other);
  }

  @override
  int get hashCode {
    return DurationModelMapper.ensureInitialized()
        .hashValue(this as DurationModel);
  }
}

extension DurationModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, DurationModel, $Out> {
  DurationModelCopyWith<$R, DurationModel, $Out> get $asDurationModel =>
      $base.as((v, t, t2) => _DurationModelCopyWithImpl(v, t, t2));
}

abstract class DurationModelCopyWith<$R, $In extends DurationModel, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({Duration? duration});
  DurationModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _DurationModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DurationModel, $Out>
    implements DurationModelCopyWith<$R, DurationModel, $Out> {
  _DurationModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<DurationModel> $mapper =
      DurationModelMapper.ensureInitialized();
  @override
  $R call({Duration? duration}) =>
      $apply(FieldCopyWithData({if (duration != null) #duration: duration}));
  @override
  DurationModel $make(CopyWithData data) =>
      DurationModel(data.get(#duration, or: $value.duration));

  @override
  DurationModelCopyWith<$R2, DurationModel, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _DurationModelCopyWithImpl($value, $cast, t);
}
