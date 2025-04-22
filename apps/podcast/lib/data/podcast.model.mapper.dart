// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'podcast.model.dart';

class PodcastMapper extends ClassMapperBase<Podcast> {
  PodcastMapper._();

  static PodcastMapper? _instance;
  static PodcastMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PodcastMapper._());
      UriModelMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'Podcast';

  static String _$id(Podcast v) => v.id;
  static const Field<Podcast, String> _f$id =
      Field('id', _$id, key: r'rss_url');
  static String _$name(Podcast v) => v.name;
  static const Field<Podcast, String> _f$name = Field('name', _$name);
  static String _$link(Podcast v) => v.link;
  static const Field<Podcast, String> _f$link = Field('link', _$link);
  static String _$description(Podcast v) => v.description;
  static const Field<Podcast, String> _f$description =
      Field('description', _$description);
  static UriModel _$backingImageUrl(Podcast v) => v.backingImageUrl;
  static const Field<Podcast, UriModel> _f$backingImageUrl =
      Field('backingImageUrl', _$backingImageUrl, key: r'backing_image_url');
  static String? _$language(Podcast v) => v.language;
  static const Field<Podcast, String> _f$language =
      Field('language', _$language, opt: true);
  static String? _$lastBuildDate(Podcast v) => v.lastBuildDate;
  static const Field<Podcast, String> _f$lastBuildDate = Field(
      'lastBuildDate', _$lastBuildDate,
      key: r'last_build_date', opt: true);
  static String? _$copyright(Podcast v) => v.copyright;
  static const Field<Podcast, String> _f$copyright =
      Field('copyright', _$copyright, opt: true);
  static String? _$generator(Podcast v) => v.generator;
  static const Field<Podcast, String> _f$generator =
      Field('generator', _$generator, opt: true);

  @override
  final MappableFields<Podcast> fields = const {
    #id: _f$id,
    #name: _f$name,
    #link: _f$link,
    #description: _f$description,
    #backingImageUrl: _f$backingImageUrl,
    #language: _f$language,
    #lastBuildDate: _f$lastBuildDate,
    #copyright: _f$copyright,
    #generator: _f$generator,
  };

  static Podcast _instantiate(DecodingData data) {
    return Podcast(
        id: data.dec(_f$id),
        name: data.dec(_f$name),
        link: data.dec(_f$link),
        description: data.dec(_f$description),
        backingImageUrl: data.dec(_f$backingImageUrl),
        language: data.dec(_f$language),
        lastBuildDate: data.dec(_f$lastBuildDate),
        copyright: data.dec(_f$copyright),
        generator: data.dec(_f$generator));
  }

  @override
  final Function instantiate = _instantiate;

  static Podcast fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Podcast>(map);
  }

  static Podcast fromJson(String json) {
    return ensureInitialized().decodeJson<Podcast>(json);
  }
}

mixin PodcastMappable {
  String toJson() {
    return PodcastMapper.ensureInitialized()
        .encodeJson<Podcast>(this as Podcast);
  }

  Map<String, dynamic> toMap() {
    return PodcastMapper.ensureInitialized()
        .encodeMap<Podcast>(this as Podcast);
  }

  PodcastCopyWith<Podcast, Podcast, Podcast> get copyWith =>
      _PodcastCopyWithImpl<Podcast, Podcast>(
          this as Podcast, $identity, $identity);
  @override
  String toString() {
    return PodcastMapper.ensureInitialized().stringifyValue(this as Podcast);
  }

  @override
  bool operator ==(Object other) {
    return PodcastMapper.ensureInitialized()
        .equalsValue(this as Podcast, other);
  }

  @override
  int get hashCode {
    return PodcastMapper.ensureInitialized().hashValue(this as Podcast);
  }
}

extension PodcastValueCopy<$R, $Out> on ObjectCopyWith<$R, Podcast, $Out> {
  PodcastCopyWith<$R, Podcast, $Out> get $asPodcast =>
      $base.as((v, t, t2) => _PodcastCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class PodcastCopyWith<$R, $In extends Podcast, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  UriModelCopyWith<$R, UriModel, UriModel> get backingImageUrl;
  $R call(
      {String? id,
      String? name,
      String? link,
      String? description,
      UriModel? backingImageUrl,
      String? language,
      String? lastBuildDate,
      String? copyright,
      String? generator});
  PodcastCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _PodcastCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, Podcast, $Out>
    implements PodcastCopyWith<$R, Podcast, $Out> {
  _PodcastCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Podcast> $mapper =
      PodcastMapper.ensureInitialized();
  @override
  UriModelCopyWith<$R, UriModel, UriModel> get backingImageUrl =>
      $value.backingImageUrl.copyWith.$chain((v) => call(backingImageUrl: v));
  @override
  $R call(
          {String? id,
          String? name,
          String? link,
          String? description,
          UriModel? backingImageUrl,
          Object? language = $none,
          Object? lastBuildDate = $none,
          Object? copyright = $none,
          Object? generator = $none}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (name != null) #name: name,
        if (link != null) #link: link,
        if (description != null) #description: description,
        if (backingImageUrl != null) #backingImageUrl: backingImageUrl,
        if (language != $none) #language: language,
        if (lastBuildDate != $none) #lastBuildDate: lastBuildDate,
        if (copyright != $none) #copyright: copyright,
        if (generator != $none) #generator: generator
      }));
  @override
  Podcast $make(CopyWithData data) => Podcast(
      id: data.get(#id, or: $value.id),
      name: data.get(#name, or: $value.name),
      link: data.get(#link, or: $value.link),
      description: data.get(#description, or: $value.description),
      backingImageUrl: data.get(#backingImageUrl, or: $value.backingImageUrl),
      language: data.get(#language, or: $value.language),
      lastBuildDate: data.get(#lastBuildDate, or: $value.lastBuildDate),
      copyright: data.get(#copyright, or: $value.copyright),
      generator: data.get(#generator, or: $value.generator));

  @override
  PodcastCopyWith<$R2, Podcast, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _PodcastCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
