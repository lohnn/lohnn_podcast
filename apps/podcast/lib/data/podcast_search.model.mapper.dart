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
    }
    return _instance!;
  }

  @override
  final String id = 'PodcastSearch';

  static int _$backingId(PodcastSearch v) => v.backingId;
  static const Field<PodcastSearch, int> _f$backingId =
      Field('backingId', _$backingId, key: r'id');
  static String _$backingUrl(PodcastSearch v) => v.backingUrl;
  static const Field<PodcastSearch, String> _f$backingUrl =
      Field('backingUrl', _$backingUrl, key: r'url');
  static String _$title(PodcastSearch v) => v.title;
  static const Field<PodcastSearch, String> _f$title = Field('title', _$title);
  static String _$description(PodcastSearch v) => v.description;
  static const Field<PodcastSearch, String> _f$description =
      Field('description', _$description);
  static String _$backingArtwork(PodcastSearch v) => v.backingArtwork;
  static const Field<PodcastSearch, String> _f$backingArtwork =
      Field('backingArtwork', _$backingArtwork, key: r'artwork');
  static String _$author(PodcastSearch v) => v.author;
  static const Field<PodcastSearch, String> _f$author =
      Field('author', _$author);
  static int? _$newestItemPublishTime(PodcastSearch v) =>
      v.newestItemPublishTime;
  static const Field<PodcastSearch, int> _f$newestItemPublishTime =
      Field('newestItemPublishTime', _$newestItemPublishTime);
  static int? _$lastUpdateTime(PodcastSearch v) => v.lastUpdateTime;
  static const Field<PodcastSearch, int> _f$lastUpdateTime =
      Field('lastUpdateTime', _$lastUpdateTime);
  static String _$language(PodcastSearch v) => v.language;
  static const Field<PodcastSearch, String> _f$language =
      Field('language', _$language);
  static Map<int, String> _$categories(PodcastSearch v) => v.categories;
  static const Field<PodcastSearch, Map<int, String>> _f$categories =
      Field('categories', _$categories, opt: true, def: const {});

  @override
  final MappableFields<PodcastSearch> fields = const {
    #backingId: _f$backingId,
    #backingUrl: _f$backingUrl,
    #title: _f$title,
    #description: _f$description,
    #backingArtwork: _f$backingArtwork,
    #author: _f$author,
    #newestItemPublishTime: _f$newestItemPublishTime,
    #lastUpdateTime: _f$lastUpdateTime,
    #language: _f$language,
    #categories: _f$categories,
  };

  static PodcastSearch _instantiate(DecodingData data) {
    return PodcastSearch(
        backingId: data.dec(_f$backingId),
        backingUrl: data.dec(_f$backingUrl),
        title: data.dec(_f$title),
        description: data.dec(_f$description),
        backingArtwork: data.dec(_f$backingArtwork),
        author: data.dec(_f$author),
        newestItemPublishTime: data.dec(_f$newestItemPublishTime),
        lastUpdateTime: data.dec(_f$lastUpdateTime),
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
  MapCopyWith<$R, int, String, ObjectCopyWith<$R, String, String>>
      get categories;
  $R call(
      {int? backingId,
      String? backingUrl,
      String? title,
      String? description,
      String? backingArtwork,
      String? author,
      int? newestItemPublishTime,
      int? lastUpdateTime,
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
  MapCopyWith<$R, int, String, ObjectCopyWith<$R, String, String>>
      get categories => MapCopyWith(
          $value.categories,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(categories: v));
  @override
  $R call(
          {int? backingId,
          String? backingUrl,
          String? title,
          String? description,
          String? backingArtwork,
          String? author,
          Object? newestItemPublishTime = $none,
          Object? lastUpdateTime = $none,
          String? language,
          Map<int, String>? categories}) =>
      $apply(FieldCopyWithData({
        if (backingId != null) #backingId: backingId,
        if (backingUrl != null) #backingUrl: backingUrl,
        if (title != null) #title: title,
        if (description != null) #description: description,
        if (backingArtwork != null) #backingArtwork: backingArtwork,
        if (author != null) #author: author,
        if (newestItemPublishTime != $none)
          #newestItemPublishTime: newestItemPublishTime,
        if (lastUpdateTime != $none) #lastUpdateTime: lastUpdateTime,
        if (language != null) #language: language,
        if (categories != null) #categories: categories
      }));
  @override
  PodcastSearch $make(CopyWithData data) => PodcastSearch(
      backingId: data.get(#backingId, or: $value.backingId),
      backingUrl: data.get(#backingUrl, or: $value.backingUrl),
      title: data.get(#title, or: $value.title),
      description: data.get(#description, or: $value.description),
      backingArtwork: data.get(#backingArtwork, or: $value.backingArtwork),
      author: data.get(#author, or: $value.author),
      newestItemPublishTime:
          data.get(#newestItemPublishTime, or: $value.newestItemPublishTime),
      lastUpdateTime: data.get(#lastUpdateTime, or: $value.lastUpdateTime),
      language: data.get(#language, or: $value.language),
      categories: data.get(#categories, or: $value.categories));

  @override
  PodcastSearchCopyWith<$R2, PodcastSearch, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _PodcastSearchCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
