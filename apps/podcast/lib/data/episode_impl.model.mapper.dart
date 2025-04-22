// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'episode_impl.model.dart';

class EpisodeImplMapper extends ClassMapperBase<EpisodeImpl> {
  EpisodeImplMapper._();

  static EpisodeImplMapper? _instance;
  static EpisodeImplMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = EpisodeImplMapper._());
      UriModelMapper.ensureInitialized();
      DurationModelMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'EpisodeImpl';

  static String _$id(EpisodeImpl v) => v.id;
  static const Field<EpisodeImpl, String> _f$id = Field('id', _$id);
  static UriModel _$backingUrl(EpisodeImpl v) => v.backingUrl;
  static const Field<EpisodeImpl, UriModel> _f$backingUrl =
      Field('backingUrl', _$backingUrl);
  static String _$title(EpisodeImpl v) => v.title;
  static const Field<EpisodeImpl, String> _f$title = Field('title', _$title);
  static DateTime? _$pubDate(EpisodeImpl v) => v.pubDate;
  static const Field<EpisodeImpl, DateTime> _f$pubDate =
      Field('pubDate', _$pubDate, opt: true);
  static String? _$description(EpisodeImpl v) => v.description;
  static const Field<EpisodeImpl, String> _f$description =
      Field('description', _$description, opt: true);
  static UriModel _$backingImageUrl(EpisodeImpl v) => v.backingImageUrl;
  static const Field<EpisodeImpl, UriModel> _f$backingImageUrl =
      Field('backingImageUrl', _$backingImageUrl);
  static DurationModel? _$backingDuration(EpisodeImpl v) => v.backingDuration;
  static const Field<EpisodeImpl, DurationModel> _f$backingDuration =
      Field('backingDuration', _$backingDuration, opt: true);
  static String _$podcastId(EpisodeImpl v) => v.podcastId;
  static const Field<EpisodeImpl, String> _f$podcastId =
      Field('podcastId', _$podcastId);

  @override
  final MappableFields<EpisodeImpl> fields = const {
    #id: _f$id,
    #backingUrl: _f$backingUrl,
    #title: _f$title,
    #pubDate: _f$pubDate,
    #description: _f$description,
    #backingImageUrl: _f$backingImageUrl,
    #backingDuration: _f$backingDuration,
    #podcastId: _f$podcastId,
  };

  static EpisodeImpl _instantiate(DecodingData data) {
    return EpisodeImpl(
        id: data.dec(_f$id),
        backingUrl: data.dec(_f$backingUrl),
        title: data.dec(_f$title),
        pubDate: data.dec(_f$pubDate),
        description: data.dec(_f$description),
        backingImageUrl: data.dec(_f$backingImageUrl),
        backingDuration: data.dec(_f$backingDuration),
        podcastId: data.dec(_f$podcastId));
  }

  @override
  final Function instantiate = _instantiate;

  static EpisodeImpl fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<EpisodeImpl>(map);
  }

  static EpisodeImpl fromJson(String json) {
    return ensureInitialized().decodeJson<EpisodeImpl>(json);
  }
}

mixin EpisodeImplMappable {
  String toJson() {
    return EpisodeImplMapper.ensureInitialized()
        .encodeJson<EpisodeImpl>(this as EpisodeImpl);
  }

  Map<String, dynamic> toMap() {
    return EpisodeImplMapper.ensureInitialized()
        .encodeMap<EpisodeImpl>(this as EpisodeImpl);
  }

  EpisodeImplCopyWith<EpisodeImpl, EpisodeImpl, EpisodeImpl> get copyWith =>
      _EpisodeImplCopyWithImpl<EpisodeImpl, EpisodeImpl>(
          this as EpisodeImpl, $identity, $identity);
  @override
  String toString() {
    return EpisodeImplMapper.ensureInitialized()
        .stringifyValue(this as EpisodeImpl);
  }

  @override
  bool operator ==(Object other) {
    return EpisodeImplMapper.ensureInitialized()
        .equalsValue(this as EpisodeImpl, other);
  }

  @override
  int get hashCode {
    return EpisodeImplMapper.ensureInitialized().hashValue(this as EpisodeImpl);
  }
}

extension EpisodeImplValueCopy<$R, $Out>
    on ObjectCopyWith<$R, EpisodeImpl, $Out> {
  EpisodeImplCopyWith<$R, EpisodeImpl, $Out> get $asEpisodeImpl =>
      $base.as((v, t, t2) => _EpisodeImplCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class EpisodeImplCopyWith<$R, $In extends EpisodeImpl, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  UriModelCopyWith<$R, UriModel, UriModel> get backingUrl;
  UriModelCopyWith<$R, UriModel, UriModel> get backingImageUrl;
  DurationModelCopyWith<$R, DurationModel, DurationModel>? get backingDuration;
  $R call(
      {String? id,
      UriModel? backingUrl,
      String? title,
      DateTime? pubDate,
      String? description,
      UriModel? backingImageUrl,
      DurationModel? backingDuration,
      String? podcastId});
  EpisodeImplCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _EpisodeImplCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, EpisodeImpl, $Out>
    implements EpisodeImplCopyWith<$R, EpisodeImpl, $Out> {
  _EpisodeImplCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<EpisodeImpl> $mapper =
      EpisodeImplMapper.ensureInitialized();
  @override
  UriModelCopyWith<$R, UriModel, UriModel> get backingUrl =>
      $value.backingUrl.copyWith.$chain((v) => call(backingUrl: v));
  @override
  UriModelCopyWith<$R, UriModel, UriModel> get backingImageUrl =>
      $value.backingImageUrl.copyWith.$chain((v) => call(backingImageUrl: v));
  @override
  DurationModelCopyWith<$R, DurationModel, DurationModel>?
      get backingDuration => $value.backingDuration?.copyWith
          .$chain((v) => call(backingDuration: v));
  @override
  $R call(
          {String? id,
          UriModel? backingUrl,
          String? title,
          Object? pubDate = $none,
          Object? description = $none,
          UriModel? backingImageUrl,
          Object? backingDuration = $none,
          String? podcastId}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (backingUrl != null) #backingUrl: backingUrl,
        if (title != null) #title: title,
        if (pubDate != $none) #pubDate: pubDate,
        if (description != $none) #description: description,
        if (backingImageUrl != null) #backingImageUrl: backingImageUrl,
        if (backingDuration != $none) #backingDuration: backingDuration,
        if (podcastId != null) #podcastId: podcastId
      }));
  @override
  EpisodeImpl $make(CopyWithData data) => EpisodeImpl(
      id: data.get(#id, or: $value.id),
      backingUrl: data.get(#backingUrl, or: $value.backingUrl),
      title: data.get(#title, or: $value.title),
      pubDate: data.get(#pubDate, or: $value.pubDate),
      description: data.get(#description, or: $value.description),
      backingImageUrl: data.get(#backingImageUrl, or: $value.backingImageUrl),
      backingDuration: data.get(#backingDuration, or: $value.backingDuration),
      podcastId: data.get(#podcastId, or: $value.podcastId));

  @override
  EpisodeImplCopyWith<$R2, EpisodeImpl, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _EpisodeImplCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
