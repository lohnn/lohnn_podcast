// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'podcast_search_impl.dart';

class PodcastSearchImplMapper extends ClassMapperBase<PodcastSearchImpl> {
  PodcastSearchImplMapper._();

  static PodcastSearchImplMapper? _instance;
  static PodcastSearchImplMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PodcastSearchImplMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'PodcastSearchImpl';

  static Uri _$artwork(PodcastSearchImpl v) => v.artwork;
  static const Field<PodcastSearchImpl, Uri> _f$artwork =
      Field('artwork', _$artwork);
  static String _$author(PodcastSearchImpl v) => v.author;
  static const Field<PodcastSearchImpl, String> _f$author =
      Field('author', _$author);
  static Map<int, String> _$categories(PodcastSearchImpl v) => v.categories;
  static const Field<PodcastSearchImpl, Map<int, String>> _f$categories =
      Field('categories', _$categories);
  static String _$description(PodcastSearchImpl v) => v.description;
  static const Field<PodcastSearchImpl, String> _f$description =
      Field('description', _$description);
  static PodcastSearchId _$id(PodcastSearchImpl v) => v.id;
  static const Field<PodcastSearchImpl, PodcastSearchId> _f$id =
      Field('id', _$id);
  static String _$language(PodcastSearchImpl v) => v.language;
  static const Field<PodcastSearchImpl, String> _f$language =
      Field('language', _$language);
  static DateTime _$lastPublished(PodcastSearchImpl v) => v.lastPublished;
  static const Field<PodcastSearchImpl, DateTime> _f$lastPublished =
      Field('lastPublished', _$lastPublished, key: r'newestItemPublishTime');
  static String _$title(PodcastSearchImpl v) => v.title;
  static const Field<PodcastSearchImpl, String> _f$title =
      Field('title', _$title);
  static PodcastRssUrl _$url(PodcastSearchImpl v) => v.url;
  static const Field<PodcastSearchImpl, PodcastRssUrl> _f$url =
      Field('url', _$url);

  @override
  final MappableFields<PodcastSearchImpl> fields = const {
    #artwork: _f$artwork,
    #author: _f$author,
    #categories: _f$categories,
    #description: _f$description,
    #id: _f$id,
    #language: _f$language,
    #lastPublished: _f$lastPublished,
    #title: _f$title,
    #url: _f$url,
  };

  static PodcastSearchImpl _instantiate(DecodingData data) {
    return PodcastSearchImpl(
        artwork: data.dec(_f$artwork),
        author: data.dec(_f$author),
        categories: data.dec(_f$categories),
        description: data.dec(_f$description),
        id: data.dec(_f$id),
        language: data.dec(_f$language),
        lastPublished: data.dec(_f$lastPublished),
        title: data.dec(_f$title),
        url: data.dec(_f$url));
  }

  @override
  final Function instantiate = _instantiate;

  static PodcastSearchImpl fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PodcastSearchImpl>(map);
  }

  static PodcastSearchImpl fromJson(String json) {
    return ensureInitialized().decodeJson<PodcastSearchImpl>(json);
  }
}

mixin PodcastSearchImplMappable {
  String toJson() {
    return PodcastSearchImplMapper.ensureInitialized()
        .encodeJson<PodcastSearchImpl>(this as PodcastSearchImpl);
  }

  Map<String, dynamic> toMap() {
    return PodcastSearchImplMapper.ensureInitialized()
        .encodeMap<PodcastSearchImpl>(this as PodcastSearchImpl);
  }

  PodcastSearchImplCopyWith<PodcastSearchImpl, PodcastSearchImpl,
          PodcastSearchImpl>
      get copyWith =>
          _PodcastSearchImplCopyWithImpl<PodcastSearchImpl, PodcastSearchImpl>(
              this as PodcastSearchImpl, $identity, $identity);
  @override
  String toString() {
    return PodcastSearchImplMapper.ensureInitialized()
        .stringifyValue(this as PodcastSearchImpl);
  }

  @override
  bool operator ==(Object other) {
    return PodcastSearchImplMapper.ensureInitialized()
        .equalsValue(this as PodcastSearchImpl, other);
  }

  @override
  int get hashCode {
    return PodcastSearchImplMapper.ensureInitialized()
        .hashValue(this as PodcastSearchImpl);
  }
}

extension PodcastSearchImplValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PodcastSearchImpl, $Out> {
  PodcastSearchImplCopyWith<$R, PodcastSearchImpl, $Out>
      get $asPodcastSearchImpl => $base
          .as((v, t, t2) => _PodcastSearchImplCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class PodcastSearchImplCopyWith<$R, $In extends PodcastSearchImpl,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, int, String, ObjectCopyWith<$R, String, String>>
      get categories;
  $R call(
      {Uri? artwork,
      String? author,
      Map<int, String>? categories,
      String? description,
      PodcastSearchId? id,
      String? language,
      DateTime? lastPublished,
      String? title,
      PodcastRssUrl? url});
  PodcastSearchImplCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _PodcastSearchImplCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PodcastSearchImpl, $Out>
    implements PodcastSearchImplCopyWith<$R, PodcastSearchImpl, $Out> {
  _PodcastSearchImplCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PodcastSearchImpl> $mapper =
      PodcastSearchImplMapper.ensureInitialized();
  @override
  MapCopyWith<$R, int, String, ObjectCopyWith<$R, String, String>>
      get categories => MapCopyWith(
          $value.categories,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(categories: v));
  @override
  $R call(
          {Uri? artwork,
          String? author,
          Map<int, String>? categories,
          String? description,
          PodcastSearchId? id,
          String? language,
          DateTime? lastPublished,
          String? title,
          PodcastRssUrl? url}) =>
      $apply(FieldCopyWithData({
        if (artwork != null) #artwork: artwork,
        if (author != null) #author: author,
        if (categories != null) #categories: categories,
        if (description != null) #description: description,
        if (id != null) #id: id,
        if (language != null) #language: language,
        if (lastPublished != null) #lastPublished: lastPublished,
        if (title != null) #title: title,
        if (url != null) #url: url
      }));
  @override
  PodcastSearchImpl $make(CopyWithData data) => PodcastSearchImpl(
      artwork: data.get(#artwork, or: $value.artwork),
      author: data.get(#author, or: $value.author),
      categories: data.get(#categories, or: $value.categories),
      description: data.get(#description, or: $value.description),
      id: data.get(#id, or: $value.id),
      language: data.get(#language, or: $value.language),
      lastPublished: data.get(#lastPublished, or: $value.lastPublished),
      title: data.get(#title, or: $value.title),
      url: data.get(#url, or: $value.url));

  @override
  PodcastSearchImplCopyWith<$R2, PodcastSearchImpl, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _PodcastSearchImplCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
