// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'podcast_search.model.dart';

class PodcastSearchMapper extends ClassMapperBase<PodcastSearch> {
  PodcastSearchMapper._();

  static PodcastSearchMapper? _instance;
  static PodcastSearchMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PodcastSearchMapper._());
      UriModelMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'PodcastSearch';

  static int _$id(PodcastSearch v) => v.id;
  static const Field<PodcastSearch, int> _f$id = Field('id', _$id);
  static UriModel _$backingUrl(PodcastSearch v) => v.backingUrl;
  static const Field<PodcastSearch, UriModel> _f$backingUrl =
      Field('backingUrl', _$backingUrl, key: r'url');
  static String _$title(PodcastSearch v) => v.title;
  static const Field<PodcastSearch, String> _f$title = Field('title', _$title);
  static String _$description(PodcastSearch v) => v.description;
  static const Field<PodcastSearch, String> _f$description =
      Field('description', _$description);
  static UriModel _$backingArtwork(PodcastSearch v) => v.backingArtwork;
  static const Field<PodcastSearch, UriModel> _f$backingArtwork =
      Field('backingArtwork', _$backingArtwork, key: r'artwork');
  static String _$author(PodcastSearch v) => v.author;
  static const Field<PodcastSearch, String> _f$author =
      Field('author', _$author);
  static String _$lastPublished(PodcastSearch v) => v.lastPublished;
  static const Field<PodcastSearch, String> _f$lastPublished =
      Field('lastPublished', _$lastPublished);
  static String _$language(PodcastSearch v) => v.language;
  static const Field<PodcastSearch, String> _f$language =
      Field('language', _$language);
  static Map<int, String> _$categories(PodcastSearch v) => v.categories;
  static const Field<PodcastSearch, Map<int, String>> _f$categories =
      Field('categories', _$categories, opt: true, def: const {});

  @override
  final MappableFields<PodcastSearch> fields = const {
    #id: _f$id,
    #backingUrl: _f$backingUrl,
    #title: _f$title,
    #description: _f$description,
    #backingArtwork: _f$backingArtwork,
    #author: _f$author,
    #lastPublished: _f$lastPublished,
    #language: _f$language,
    #categories: _f$categories,
  };

  static PodcastSearch _instantiate(DecodingData data) {
    return PodcastSearch(
        id: data.dec(_f$id),
        backingUrl: data.dec(_f$backingUrl),
        title: data.dec(_f$title),
        description: data.dec(_f$description),
        backingArtwork: data.dec(_f$backingArtwork),
        author: data.dec(_f$author),
        lastPublished: data.dec(_f$lastPublished),
        language: data.dec(_f$language),
        categories: data.dec(_f$categories));
  }

  @override
  final Function instantiate = _instantiate;

  static PodcastSearch fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PodcastSearch>(map);
  }

  static PodcastSearch fromJson(String json) {
    return ensureInitialized().decodeJson<PodcastSearch>(json);
  }
}

mixin PodcastSearchMappable {
  String toJson() {
    return PodcastSearchMapper.ensureInitialized()
        .encodeJson<PodcastSearch>(this as PodcastSearch);
  }

  Map<String, dynamic> toMap() {
    return PodcastSearchMapper.ensureInitialized()
        .encodeMap<PodcastSearch>(this as PodcastSearch);
  }

  PodcastSearchCopyWith<PodcastSearch, PodcastSearch, PodcastSearch>
      get copyWith => _PodcastSearchCopyWithImpl<PodcastSearch, PodcastSearch>(
          this as PodcastSearch, $identity, $identity);
  @override
  String toString() {
    return PodcastSearchMapper.ensureInitialized()
        .stringifyValue(this as PodcastSearch);
  }

  @override
  bool operator ==(Object other) {
    return PodcastSearchMapper.ensureInitialized()
        .equalsValue(this as PodcastSearch, other);
  }

  @override
  int get hashCode {
    return PodcastSearchMapper.ensureInitialized()
        .hashValue(this as PodcastSearch);
  }
}

extension PodcastSearchValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PodcastSearch, $Out> {
  PodcastSearchCopyWith<$R, PodcastSearch, $Out> get $asPodcastSearch =>
      $base.as((v, t, t2) => _PodcastSearchCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class PodcastSearchCopyWith<$R, $In extends PodcastSearch, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  UriModelCopyWith<$R, UriModel, UriModel> get backingUrl;
  UriModelCopyWith<$R, UriModel, UriModel> get backingArtwork;
  MapCopyWith<$R, int, String, ObjectCopyWith<$R, String, String>>
      get categories;
  $R call(
      {int? id,
      UriModel? backingUrl,
      String? title,
      String? description,
      UriModel? backingArtwork,
      String? author,
      String? lastPublished,
      String? language,
      Map<int, String>? categories});
  PodcastSearchCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _PodcastSearchCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PodcastSearch, $Out>
    implements PodcastSearchCopyWith<$R, PodcastSearch, $Out> {
  _PodcastSearchCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PodcastSearch> $mapper =
      PodcastSearchMapper.ensureInitialized();
  @override
  UriModelCopyWith<$R, UriModel, UriModel> get backingUrl =>
      $value.backingUrl.copyWith.$chain((v) => call(backingUrl: v));
  @override
  UriModelCopyWith<$R, UriModel, UriModel> get backingArtwork =>
      $value.backingArtwork.copyWith.$chain((v) => call(backingArtwork: v));
  @override
  MapCopyWith<$R, int, String, ObjectCopyWith<$R, String, String>>
      get categories => MapCopyWith(
          $value.categories,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(categories: v));
  @override
  $R call(
          {int? id,
          UriModel? backingUrl,
          String? title,
          String? description,
          UriModel? backingArtwork,
          String? author,
          String? lastPublished,
          String? language,
          Map<int, String>? categories}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (backingUrl != null) #backingUrl: backingUrl,
        if (title != null) #title: title,
        if (description != null) #description: description,
        if (backingArtwork != null) #backingArtwork: backingArtwork,
        if (author != null) #author: author,
        if (lastPublished != null) #lastPublished: lastPublished,
        if (language != null) #language: language,
        if (categories != null) #categories: categories
      }));
  @override
  PodcastSearch $make(CopyWithData data) => PodcastSearch(
      id: data.get(#id, or: $value.id),
      backingUrl: data.get(#backingUrl, or: $value.backingUrl),
      title: data.get(#title, or: $value.title),
      description: data.get(#description, or: $value.description),
      backingArtwork: data.get(#backingArtwork, or: $value.backingArtwork),
      author: data.get(#author, or: $value.author),
      lastPublished: data.get(#lastPublished, or: $value.lastPublished),
      language: data.get(#language, or: $value.language),
      categories: data.get(#categories, or: $value.categories));

  @override
  PodcastSearchCopyWith<$R2, PodcastSearch, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _PodcastSearchCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
