// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'episode_supabase.model.dart';

class EpisodeSupabaseMapper extends ClassMapperBase<EpisodeSupabase> {
  EpisodeSupabaseMapper._();

  static EpisodeSupabaseMapper? _instance;
  static EpisodeSupabaseMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = EpisodeSupabaseMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'EpisodeSupabase';

  static String _$id(EpisodeSupabase v) => v.id;
  static const Field<EpisodeSupabase, String> _f$id = Field('id', _$id);
  static UriModel _$url(EpisodeSupabase v) => v.url;
  static const Field<EpisodeSupabase, UriModel> _f$url = Field('url', _$url);
  static String _$title(EpisodeSupabase v) => v.title;
  static const Field<EpisodeSupabase, String> _f$title =
      Field('title', _$title);
  static DateTime? _$pubDate(EpisodeSupabase v) => v.pubDate;
  static const Field<EpisodeSupabase, DateTime> _f$pubDate =
      Field('pubDate', _$pubDate, opt: true);
  static String? _$description(EpisodeSupabase v) => v.description;
  static const Field<EpisodeSupabase, String> _f$description =
      Field('description', _$description, opt: true);
  static UriModel _$imageUrl(EpisodeSupabase v) => v.imageUrl;
  static const Field<EpisodeSupabase, UriModel> _f$imageUrl =
      Field('imageUrl', _$imageUrl);
  static EpisodeDuration? _$duration(EpisodeSupabase v) => v.duration;
  static const Field<EpisodeSupabase, EpisodeDuration> _f$duration =
      Field('duration', _$duration, opt: true);

  @override
  final MappableFields<EpisodeSupabase> fields = const {
    #id: _f$id,
    #url: _f$url,
    #title: _f$title,
    #pubDate: _f$pubDate,
    #description: _f$description,
    #imageUrl: _f$imageUrl,
    #duration: _f$duration,
  };

  static EpisodeSupabase _instantiate(DecodingData data) {
    return EpisodeSupabase(
        id: data.dec(_f$id),
        url: data.dec(_f$url),
        title: data.dec(_f$title),
        pubDate: data.dec(_f$pubDate),
        description: data.dec(_f$description),
        imageUrl: data.dec(_f$imageUrl),
        duration: data.dec(_f$duration));
  }

  @override
  final Function instantiate = _instantiate;

  static EpisodeSupabase fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<EpisodeSupabase>(map);
  }

  static EpisodeSupabase fromJson(String json) {
    return ensureInitialized().decodeJson<EpisodeSupabase>(json);
  }
}

mixin EpisodeSupabaseMappable {
  String toJson() {
    return EpisodeSupabaseMapper.ensureInitialized()
        .encodeJson<EpisodeSupabase>(this as EpisodeSupabase);
  }

  Map<String, dynamic> toMap() {
    return EpisodeSupabaseMapper.ensureInitialized()
        .encodeMap<EpisodeSupabase>(this as EpisodeSupabase);
  }

  EpisodeSupabaseCopyWith<EpisodeSupabase, EpisodeSupabase, EpisodeSupabase>
      get copyWith => _EpisodeSupabaseCopyWithImpl(
          this as EpisodeSupabase, $identity, $identity);
  @override
  String toString() {
    return EpisodeSupabaseMapper.ensureInitialized()
        .stringifyValue(this as EpisodeSupabase);
  }

  @override
  bool operator ==(Object other) {
    return EpisodeSupabaseMapper.ensureInitialized()
        .equalsValue(this as EpisodeSupabase, other);
  }

  @override
  int get hashCode {
    return EpisodeSupabaseMapper.ensureInitialized()
        .hashValue(this as EpisodeSupabase);
  }
}

extension EpisodeSupabaseValueCopy<$R, $Out>
    on ObjectCopyWith<$R, EpisodeSupabase, $Out> {
  EpisodeSupabaseCopyWith<$R, EpisodeSupabase, $Out> get $asEpisodeSupabase =>
      $base.as((v, t, t2) => _EpisodeSupabaseCopyWithImpl(v, t, t2));
}

abstract class EpisodeSupabaseCopyWith<$R, $In extends EpisodeSupabase, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? id,
      UriModel? url,
      String? title,
      DateTime? pubDate,
      String? description,
      UriModel? imageUrl,
      EpisodeDuration? duration});
  EpisodeSupabaseCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _EpisodeSupabaseCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, EpisodeSupabase, $Out>
    implements EpisodeSupabaseCopyWith<$R, EpisodeSupabase, $Out> {
  _EpisodeSupabaseCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<EpisodeSupabase> $mapper =
      EpisodeSupabaseMapper.ensureInitialized();
  @override
  $R call(
          {String? id,
          UriModel? url,
          String? title,
          Object? pubDate = $none,
          Object? description = $none,
          UriModel? imageUrl,
          Object? duration = $none}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (url != null) #url: url,
        if (title != null) #title: title,
        if (pubDate != $none) #pubDate: pubDate,
        if (description != $none) #description: description,
        if (imageUrl != null) #imageUrl: imageUrl,
        if (duration != $none) #duration: duration
      }));
  @override
  EpisodeSupabase $make(CopyWithData data) => EpisodeSupabase(
      id: data.get(#id, or: $value.id),
      url: data.get(#url, or: $value.url),
      title: data.get(#title, or: $value.title),
      pubDate: data.get(#pubDate, or: $value.pubDate),
      description: data.get(#description, or: $value.description),
      imageUrl: data.get(#imageUrl, or: $value.imageUrl),
      duration: data.get(#duration, or: $value.duration));

  @override
  EpisodeSupabaseCopyWith<$R2, EpisodeSupabase, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _EpisodeSupabaseCopyWithImpl($value, $cast, t);
}
