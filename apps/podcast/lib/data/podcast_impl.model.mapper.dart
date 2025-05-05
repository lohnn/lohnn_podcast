// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'podcast_impl.model.dart';

class PodcastImplMapper extends ClassMapperBase<PodcastImpl> {
  PodcastImplMapper._();

  static PodcastImplMapper? _instance;
  static PodcastImplMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PodcastImplMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'PodcastImpl';

  static String _$backingId(PodcastImpl v) => v.backingId;
  static const Field<PodcastImpl, String> _f$backingId =
      Field('backingId', _$backingId);
  static String _$backingUrl(PodcastImpl v) => v.backingUrl;
  static const Field<PodcastImpl, String> _f$backingUrl =
      Field('backingUrl', _$backingUrl);
  static String _$title(PodcastImpl v) => v.title;
  static const Field<PodcastImpl, String> _f$title = Field('title', _$title);
  static String _$description(PodcastImpl v) => v.description;
  static const Field<PodcastImpl, String> _f$description =
      Field('description', _$description);
  static String _$backingArtwork(PodcastImpl v) => v.backingArtwork;
  static const Field<PodcastImpl, String> _f$backingArtwork =
      Field('backingArtwork', _$backingArtwork);
  static String? _$lastPublished(PodcastImpl v) => v.lastPublished;
  static const Field<PodcastImpl, String> _f$lastPublished =
      Field('lastPublished', _$lastPublished);
  static String? _$language(PodcastImpl v) => v.language;
  static const Field<PodcastImpl, String> _f$language =
      Field('language', _$language);
  static Set<String> _$categories(PodcastImpl v) => v.categories;
  static const Field<PodcastImpl, Set<String>> _f$categories =
      Field('categories', _$categories, opt: true, def: const {});

  @override
  final MappableFields<PodcastImpl> fields = const {
    #backingId: _f$backingId,
    #backingUrl: _f$backingUrl,
    #title: _f$title,
    #description: _f$description,
    #backingArtwork: _f$backingArtwork,
    #lastPublished: _f$lastPublished,
    #language: _f$language,
    #categories: _f$categories,
  };

  static PodcastImpl _instantiate(DecodingData data) {
    return PodcastImpl(
        backingId: data.dec(_f$backingId),
        backingUrl: data.dec(_f$backingUrl),
        title: data.dec(_f$title),
        description: data.dec(_f$description),
        backingArtwork: data.dec(_f$backingArtwork),
        lastPublished: data.dec(_f$lastPublished),
        language: data.dec(_f$language),
        categories: data.dec(_f$categories));
  }

  @override
  final Function instantiate = _instantiate;

  static PodcastImpl fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PodcastImpl>(map);
  }

  static PodcastImpl fromJson(String json) {
    return ensureInitialized().decodeJson<PodcastImpl>(json);
  }
}

mixin PodcastImplMappable {
  String toJson() {
    return PodcastImplMapper.ensureInitialized()
        .encodeJson<PodcastImpl>(this as PodcastImpl);
  }

  Map<String, dynamic> toMap() {
    return PodcastImplMapper.ensureInitialized()
        .encodeMap<PodcastImpl>(this as PodcastImpl);
  }

  PodcastImplCopyWith<PodcastImpl, PodcastImpl, PodcastImpl> get copyWith =>
      _PodcastImplCopyWithImpl<PodcastImpl, PodcastImpl>(
          this as PodcastImpl, $identity, $identity);
  @override
  String toString() {
    return PodcastImplMapper.ensureInitialized()
        .stringifyValue(this as PodcastImpl);
  }

  @override
  bool operator ==(Object other) {
    return PodcastImplMapper.ensureInitialized()
        .equalsValue(this as PodcastImpl, other);
  }

  @override
  int get hashCode {
    return PodcastImplMapper.ensureInitialized().hashValue(this as PodcastImpl);
  }
}

extension PodcastImplValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PodcastImpl, $Out> {
  PodcastImplCopyWith<$R, PodcastImpl, $Out> get $asPodcastImpl =>
      $base.as((v, t, t2) => _PodcastImplCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class PodcastImplCopyWith<$R, $In extends PodcastImpl, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? backingId,
      String? backingUrl,
      String? title,
      String? description,
      String? backingArtwork,
      String? lastPublished,
      String? language,
      Set<String>? categories});
  PodcastImplCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _PodcastImplCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PodcastImpl, $Out>
    implements PodcastImplCopyWith<$R, PodcastImpl, $Out> {
  _PodcastImplCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PodcastImpl> $mapper =
      PodcastImplMapper.ensureInitialized();
  @override
  $R call(
          {String? backingId,
          String? backingUrl,
          String? title,
          String? description,
          String? backingArtwork,
          Object? lastPublished = $none,
          Object? language = $none,
          Set<String>? categories}) =>
      $apply(FieldCopyWithData({
        if (backingId != null) #backingId: backingId,
        if (backingUrl != null) #backingUrl: backingUrl,
        if (title != null) #title: title,
        if (description != null) #description: description,
        if (backingArtwork != null) #backingArtwork: backingArtwork,
        if (lastPublished != $none) #lastPublished: lastPublished,
        if (language != $none) #language: language,
        if (categories != null) #categories: categories
      }));
  @override
  PodcastImpl $make(CopyWithData data) => PodcastImpl(
      backingId: data.get(#backingId, or: $value.backingId),
      backingUrl: data.get(#backingUrl, or: $value.backingUrl),
      title: data.get(#title, or: $value.title),
      description: data.get(#description, or: $value.description),
      backingArtwork: data.get(#backingArtwork, or: $value.backingArtwork),
      lastPublished: data.get(#lastPublished, or: $value.lastPublished),
      language: data.get(#language, or: $value.language),
      categories: data.get(#categories, or: $value.categories));

  @override
  PodcastImplCopyWith<$R2, PodcastImpl, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _PodcastImplCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
