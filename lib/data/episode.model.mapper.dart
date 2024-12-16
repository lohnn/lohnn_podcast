// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'episode.model.dart';

class EpisodeMapper extends ClassMapperBase<Episode> {
  EpisodeMapper._();

  static EpisodeMapper? _instance;
  static EpisodeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = EpisodeMapper._());
      UriModelMapper.ensureInitialized();
      DurationModelMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'Episode';

  static String _$id(Episode v) => v.id;
  static const Field<Episode, String> _f$id = Field('id', _$id);
  static UriModel _$url(Episode v) => v.url;
  static const Field<Episode, UriModel> _f$url = Field('url', _$url);
  static String _$title(Episode v) => v.title;
  static const Field<Episode, String> _f$title = Field('title', _$title);
  static DateTime? _$pubDate(Episode v) => v.pubDate;
  static const Field<Episode, DateTime> _f$pubDate =
      Field('pubDate', _$pubDate, opt: true);
  static String? _$description(Episode v) => v.description;
  static const Field<Episode, String> _f$description =
      Field('description', _$description, opt: true);
  static UriModel _$imageUrl(Episode v) => v.imageUrl;
  static const Field<Episode, UriModel> _f$imageUrl =
      Field('imageUrl', _$imageUrl);
  static DurationModel? _$duration(Episode v) => v.duration;
  static const Field<Episode, DurationModel> _f$duration =
      Field('duration', _$duration, opt: true);
  static String _$podcastId(Episode v) => v.podcastId;
  static const Field<Episode, String> _f$podcastId =
      Field('podcastId', _$podcastId);

  @override
  final MappableFields<Episode> fields = const {
    #id: _f$id,
    #url: _f$url,
    #title: _f$title,
    #pubDate: _f$pubDate,
    #description: _f$description,
    #imageUrl: _f$imageUrl,
    #duration: _f$duration,
    #podcastId: _f$podcastId,
  };

  static Episode _instantiate(DecodingData data) {
    return Episode(
        id: data.dec(_f$id),
        url: data.dec(_f$url),
        title: data.dec(_f$title),
        pubDate: data.dec(_f$pubDate),
        description: data.dec(_f$description),
        imageUrl: data.dec(_f$imageUrl),
        duration: data.dec(_f$duration),
        podcastId: data.dec(_f$podcastId));
  }

  @override
  final Function instantiate = _instantiate;

  static Episode fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Episode>(map);
  }

  static Episode fromJson(String json) {
    return ensureInitialized().decodeJson<Episode>(json);
  }
}

mixin EpisodeMappable {
  String toJson() {
    return EpisodeMapper.ensureInitialized()
        .encodeJson<Episode>(this as Episode);
  }

  Map<String, dynamic> toMap() {
    return EpisodeMapper.ensureInitialized()
        .encodeMap<Episode>(this as Episode);
  }

  EpisodeCopyWith<Episode, Episode, Episode> get copyWith =>
      _EpisodeCopyWithImpl(this as Episode, $identity, $identity);
  @override
  String toString() {
    return EpisodeMapper.ensureInitialized().stringifyValue(this as Episode);
  }

  @override
  bool operator ==(Object other) {
    return EpisodeMapper.ensureInitialized()
        .equalsValue(this as Episode, other);
  }

  @override
  int get hashCode {
    return EpisodeMapper.ensureInitialized().hashValue(this as Episode);
  }
}

extension EpisodeValueCopy<$R, $Out> on ObjectCopyWith<$R, Episode, $Out> {
  EpisodeCopyWith<$R, Episode, $Out> get $asEpisode =>
      $base.as((v, t, t2) => _EpisodeCopyWithImpl(v, t, t2));
}

abstract class EpisodeCopyWith<$R, $In extends Episode, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  UriModelCopyWith<$R, UriModel, UriModel> get url;
  UriModelCopyWith<$R, UriModel, UriModel> get imageUrl;
  DurationModelCopyWith<$R, DurationModel, DurationModel>? get duration;
  $R call(
      {String? id,
      UriModel? url,
      String? title,
      DateTime? pubDate,
      String? description,
      UriModel? imageUrl,
      DurationModel? duration,
      String? podcastId});
  EpisodeCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _EpisodeCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, Episode, $Out>
    implements EpisodeCopyWith<$R, Episode, $Out> {
  _EpisodeCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Episode> $mapper =
      EpisodeMapper.ensureInitialized();
  @override
  UriModelCopyWith<$R, UriModel, UriModel> get url =>
      $value.url.copyWith.$chain((v) => call(url: v));
  @override
  UriModelCopyWith<$R, UriModel, UriModel> get imageUrl =>
      $value.imageUrl.copyWith.$chain((v) => call(imageUrl: v));
  @override
  DurationModelCopyWith<$R, DurationModel, DurationModel>? get duration =>
      $value.duration?.copyWith.$chain((v) => call(duration: v));
  @override
  $R call(
          {String? id,
          UriModel? url,
          String? title,
          Object? pubDate = $none,
          Object? description = $none,
          UriModel? imageUrl,
          Object? duration = $none,
          String? podcastId}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (url != null) #url: url,
        if (title != null) #title: title,
        if (pubDate != $none) #pubDate: pubDate,
        if (description != $none) #description: description,
        if (imageUrl != null) #imageUrl: imageUrl,
        if (duration != $none) #duration: duration,
        if (podcastId != null) #podcastId: podcastId
      }));
  @override
  Episode $make(CopyWithData data) => Episode(
      id: data.get(#id, or: $value.id),
      url: data.get(#url, or: $value.url),
      title: data.get(#title, or: $value.title),
      pubDate: data.get(#pubDate, or: $value.pubDate),
      description: data.get(#description, or: $value.description),
      imageUrl: data.get(#imageUrl, or: $value.imageUrl),
      duration: data.get(#duration, or: $value.duration),
      podcastId: data.get(#podcastId, or: $value.podcastId));

  @override
  EpisodeCopyWith<$R2, Episode, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _EpisodeCopyWithImpl($value, $cast, t);
}
