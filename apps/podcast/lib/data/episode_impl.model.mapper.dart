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
    }
    return _instance!;
  }

  @override
  final String id = 'EpisodeImpl';

  static String _$backingId(EpisodeImpl v) => v.backingId;
  static const Field<EpisodeImpl, String> _f$backingId =
      Field('backingId', _$backingId);
  static String _$backingUrl(EpisodeImpl v) => v.backingUrl;
  static const Field<EpisodeImpl, String> _f$backingUrl =
      Field('backingUrl', _$backingUrl);
  static String _$title(EpisodeImpl v) => v.title;
  static const Field<EpisodeImpl, String> _f$title = Field('title', _$title);
  static int _$datePublished(EpisodeImpl v) => v.datePublished;
  static const Field<EpisodeImpl, int> _f$datePublished =
      Field('datePublished', _$datePublished);
  static String? _$description(EpisodeImpl v) => v.description;
  static const Field<EpisodeImpl, String> _f$description =
      Field('description', _$description);
  static String _$backingImageUrl(EpisodeImpl v) => v.backingImageUrl;
  static const Field<EpisodeImpl, String> _f$backingImageUrl =
      Field('backingImageUrl', _$backingImageUrl);
  static int? _$backingDuration(EpisodeImpl v) => v.backingDuration;
  static const Field<EpisodeImpl, int> _f$backingDuration =
      Field('backingDuration', _$backingDuration);
  static String _$backingPodcastId(EpisodeImpl v) => v.backingPodcastId;
  static const Field<EpisodeImpl, String> _f$backingPodcastId =
      Field('backingPodcastId', _$backingPodcastId);

  @override
  final MappableFields<EpisodeImpl> fields = const {
    #backingId: _f$backingId,
    #backingUrl: _f$backingUrl,
    #title: _f$title,
    #datePublished: _f$datePublished,
    #description: _f$description,
    #backingImageUrl: _f$backingImageUrl,
    #backingDuration: _f$backingDuration,
    #backingPodcastId: _f$backingPodcastId,
  };

  static EpisodeImpl _instantiate(DecodingData data) {
    return EpisodeImpl(
        backingId: data.dec(_f$backingId),
        backingUrl: data.dec(_f$backingUrl),
        title: data.dec(_f$title),
        datePublished: data.dec(_f$datePublished),
        description: data.dec(_f$description),
        backingImageUrl: data.dec(_f$backingImageUrl),
        backingDuration: data.dec(_f$backingDuration),
        backingPodcastId: data.dec(_f$backingPodcastId));
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
  $R call(
      {String? backingId,
      String? backingUrl,
      String? title,
      int? datePublished,
      String? description,
      String? backingImageUrl,
      int? backingDuration,
      String? backingPodcastId});
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
  $R call(
          {String? backingId,
          String? backingUrl,
          String? title,
          int? datePublished,
          Object? description = $none,
          String? backingImageUrl,
          Object? backingDuration = $none,
          String? backingPodcastId}) =>
      $apply(FieldCopyWithData({
        if (backingId != null) #backingId: backingId,
        if (backingUrl != null) #backingUrl: backingUrl,
        if (title != null) #title: title,
        if (datePublished != null) #datePublished: datePublished,
        if (description != $none) #description: description,
        if (backingImageUrl != null) #backingImageUrl: backingImageUrl,
        if (backingDuration != $none) #backingDuration: backingDuration,
        if (backingPodcastId != null) #backingPodcastId: backingPodcastId
      }));
  @override
  EpisodeImpl $make(CopyWithData data) => EpisodeImpl(
      backingId: data.get(#backingId, or: $value.backingId),
      backingUrl: data.get(#backingUrl, or: $value.backingUrl),
      title: data.get(#title, or: $value.title),
      datePublished: data.get(#datePublished, or: $value.datePublished),
      description: data.get(#description, or: $value.description),
      backingImageUrl: data.get(#backingImageUrl, or: $value.backingImageUrl),
      backingDuration: data.get(#backingDuration, or: $value.backingDuration),
      backingPodcastId:
          data.get(#backingPodcastId, or: $value.backingPodcastId));

  @override
  EpisodeImplCopyWith<$R2, EpisodeImpl, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _EpisodeImplCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
