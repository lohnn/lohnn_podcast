// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'podcast_supabase.model.dart';

class PodcastSupabaseMapper extends ClassMapperBase<PodcastSupabase> {
  PodcastSupabaseMapper._();

  static PodcastSupabaseMapper? _instance;
  static PodcastSupabaseMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PodcastSupabaseMapper._());
      UriModelMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'PodcastSupabase';

  static String _$id(PodcastSupabase v) => v.id;
  static const Field<PodcastSupabase, String> _f$id =
      Field('id', _$id, key: 'rss_url');
  static String _$name(PodcastSupabase v) => v.name;
  static const Field<PodcastSupabase, String> _f$name = Field('name', _$name);
  static String _$link(PodcastSupabase v) => v.link;
  static const Field<PodcastSupabase, String> _f$link = Field('link', _$link);
  static String _$description(PodcastSupabase v) => v.description;
  static const Field<PodcastSupabase, String> _f$description =
      Field('description', _$description);
  static UriModel _$imageUrl(PodcastSupabase v) => v.imageUrl;
  static const Field<PodcastSupabase, UriModel> _f$imageUrl =
      Field('imageUrl', _$imageUrl, key: 'image_url');
  static String? _$language(PodcastSupabase v) => v.language;
  static const Field<PodcastSupabase, String> _f$language =
      Field('language', _$language, opt: true);
  static String? _$lastBuildDate(PodcastSupabase v) => v.lastBuildDate;
  static const Field<PodcastSupabase, String> _f$lastBuildDate = Field(
      'lastBuildDate', _$lastBuildDate,
      key: 'last_build_date', opt: true);
  static String? _$copyright(PodcastSupabase v) => v.copyright;
  static const Field<PodcastSupabase, String> _f$copyright =
      Field('copyright', _$copyright, opt: true);
  static String? _$generator(PodcastSupabase v) => v.generator;
  static const Field<PodcastSupabase, String> _f$generator =
      Field('generator', _$generator, opt: true);

  @override
  final MappableFields<PodcastSupabase> fields = const {
    #id: _f$id,
    #name: _f$name,
    #link: _f$link,
    #description: _f$description,
    #imageUrl: _f$imageUrl,
    #language: _f$language,
    #lastBuildDate: _f$lastBuildDate,
    #copyright: _f$copyright,
    #generator: _f$generator,
  };

  static PodcastSupabase _instantiate(DecodingData data) {
    return PodcastSupabase(
        id: data.dec(_f$id),
        name: data.dec(_f$name),
        link: data.dec(_f$link),
        description: data.dec(_f$description),
        imageUrl: data.dec(_f$imageUrl),
        language: data.dec(_f$language),
        lastBuildDate: data.dec(_f$lastBuildDate),
        copyright: data.dec(_f$copyright),
        generator: data.dec(_f$generator));
  }

  @override
  final Function instantiate = _instantiate;

  static PodcastSupabase fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PodcastSupabase>(map);
  }

  static PodcastSupabase fromJson(String json) {
    return ensureInitialized().decodeJson<PodcastSupabase>(json);
  }
}

mixin PodcastSupabaseMappable {
  String toJson() {
    return PodcastSupabaseMapper.ensureInitialized()
        .encodeJson<PodcastSupabase>(this as PodcastSupabase);
  }

  Map<String, dynamic> toMap() {
    return PodcastSupabaseMapper.ensureInitialized()
        .encodeMap<PodcastSupabase>(this as PodcastSupabase);
  }

  PodcastSupabaseCopyWith<PodcastSupabase, PodcastSupabase, PodcastSupabase>
      get copyWith => _PodcastSupabaseCopyWithImpl(
          this as PodcastSupabase, $identity, $identity);
  @override
  String toString() {
    return PodcastSupabaseMapper.ensureInitialized()
        .stringifyValue(this as PodcastSupabase);
  }

  @override
  bool operator ==(Object other) {
    return PodcastSupabaseMapper.ensureInitialized()
        .equalsValue(this as PodcastSupabase, other);
  }

  @override
  int get hashCode {
    return PodcastSupabaseMapper.ensureInitialized()
        .hashValue(this as PodcastSupabase);
  }
}

extension PodcastSupabaseValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PodcastSupabase, $Out> {
  PodcastSupabaseCopyWith<$R, PodcastSupabase, $Out> get $asPodcastSupabase =>
      $base.as((v, t, t2) => _PodcastSupabaseCopyWithImpl(v, t, t2));
}

abstract class PodcastSupabaseCopyWith<$R, $In extends PodcastSupabase, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  UriModelCopyWith<$R, UriModel, UriModel> get imageUrl;
  $R call(
      {String? id,
      String? name,
      String? link,
      String? description,
      UriModel? imageUrl,
      String? language,
      String? lastBuildDate,
      String? copyright,
      String? generator});
  PodcastSupabaseCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _PodcastSupabaseCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PodcastSupabase, $Out>
    implements PodcastSupabaseCopyWith<$R, PodcastSupabase, $Out> {
  _PodcastSupabaseCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PodcastSupabase> $mapper =
      PodcastSupabaseMapper.ensureInitialized();
  @override
  UriModelCopyWith<$R, UriModel, UriModel> get imageUrl =>
      $value.imageUrl.copyWith.$chain((v) => call(imageUrl: v));
  @override
  $R call(
          {String? id,
          String? name,
          String? link,
          String? description,
          UriModel? imageUrl,
          Object? language = $none,
          Object? lastBuildDate = $none,
          Object? copyright = $none,
          Object? generator = $none}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (name != null) #name: name,
        if (link != null) #link: link,
        if (description != null) #description: description,
        if (imageUrl != null) #imageUrl: imageUrl,
        if (language != $none) #language: language,
        if (lastBuildDate != $none) #lastBuildDate: lastBuildDate,
        if (copyright != $none) #copyright: copyright,
        if (generator != $none) #generator: generator
      }));
  @override
  PodcastSupabase $make(CopyWithData data) => PodcastSupabase(
      id: data.get(#id, or: $value.id),
      name: data.get(#name, or: $value.name),
      link: data.get(#link, or: $value.link),
      description: data.get(#description, or: $value.description),
      imageUrl: data.get(#imageUrl, or: $value.imageUrl),
      language: data.get(#language, or: $value.language),
      lastBuildDate: data.get(#lastBuildDate, or: $value.lastBuildDate),
      copyright: data.get(#copyright, or: $value.copyright),
      generator: data.get(#generator, or: $value.generator));

  @override
  PodcastSupabaseCopyWith<$R2, PodcastSupabase, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _PodcastSupabaseCopyWithImpl($value, $cast, t);
}
