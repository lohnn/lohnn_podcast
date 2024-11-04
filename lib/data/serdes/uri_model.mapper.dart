// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'uri_model.dart';

class UriModelMapper extends ClassMapperBase<UriModel> {
  UriModelMapper._();

  static UriModelMapper? _instance;
  static UriModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UriModelMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'UriModel';

  static const Field<UriModel, String> _f$url =
      Field('url', null, mode: FieldMode.param);
  static Uri _$uri(UriModel v) => v.uri;
  static const Field<UriModel, Uri> _f$uri =
      Field('uri', _$uri, mode: FieldMode.member);

  @override
  final MappableFields<UriModel> fields = const {
    #url: _f$url,
    #uri: _f$uri,
  };

  static UriModel _instantiate(DecodingData data) {
    return UriModel(data.dec(_f$url));
  }

  @override
  final Function instantiate = _instantiate;

  static UriModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<UriModel>(map);
  }

  static UriModel fromJson(String json) {
    return ensureInitialized().decodeJson<UriModel>(json);
  }
}

mixin UriModelMappable {
  String toJson() {
    return UriModelMapper.ensureInitialized()
        .encodeJson<UriModel>(this as UriModel);
  }

  Map<String, dynamic> toMap() {
    return UriModelMapper.ensureInitialized()
        .encodeMap<UriModel>(this as UriModel);
  }

  UriModelCopyWith<UriModel, UriModel, UriModel> get copyWith =>
      _UriModelCopyWithImpl(this as UriModel, $identity, $identity);
  @override
  String toString() {
    return UriModelMapper.ensureInitialized().stringifyValue(this as UriModel);
  }

  @override
  bool operator ==(Object other) {
    return UriModelMapper.ensureInitialized()
        .equalsValue(this as UriModel, other);
  }

  @override
  int get hashCode {
    return UriModelMapper.ensureInitialized().hashValue(this as UriModel);
  }
}

extension UriModelValueCopy<$R, $Out> on ObjectCopyWith<$R, UriModel, $Out> {
  UriModelCopyWith<$R, UriModel, $Out> get $asUriModel =>
      $base.as((v, t, t2) => _UriModelCopyWithImpl(v, t, t2));
}

abstract class UriModelCopyWith<$R, $In extends UriModel, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({required String url});
  UriModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _UriModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, UriModel, $Out>
    implements UriModelCopyWith<$R, UriModel, $Out> {
  _UriModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<UriModel> $mapper =
      UriModelMapper.ensureInitialized();
  @override
  $R call({required String url}) => $apply(FieldCopyWithData({#url: url}));
  @override
  UriModel $make(CopyWithData data) => UriModel(data.get(#url));

  @override
  UriModelCopyWith<$R2, UriModel, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _UriModelCopyWithImpl($value, $cast, t);
}
