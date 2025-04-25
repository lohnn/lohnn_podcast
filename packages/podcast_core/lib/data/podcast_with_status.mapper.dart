// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'podcast_with_status.dart';

class PodcastWithStatusMapper extends ClassMapperBase<PodcastWithStatus> {
  PodcastWithStatusMapper._();

  static PodcastWithStatusMapper? _instance;
  static PodcastWithStatusMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PodcastWithStatusMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'PodcastWithStatus';

  static PodcastSearch _$podcast(PodcastWithStatus v) => v.podcast;
  static const Field<PodcastWithStatus, PodcastSearch> _f$podcast =
      Field('podcast', _$podcast);
  static int? _$listenedEpisodes(PodcastWithStatus v) => v.listenedEpisodes;
  static const Field<PodcastWithStatus, int> _f$listenedEpisodes =
      Field('listenedEpisodes', _$listenedEpisodes, key: r'listened_episodes');
  static int? _$totalEpisodes(PodcastWithStatus v) => v.totalEpisodes;
  static const Field<PodcastWithStatus, int> _f$totalEpisodes =
      Field('totalEpisodes', _$totalEpisodes, key: r'total_episodes');
  static bool? _$hasUnseenEpisodes(PodcastWithStatus v) => v.hasUnseenEpisodes;
  static const Field<PodcastWithStatus, bool> _f$hasUnseenEpisodes = Field(
      'hasUnseenEpisodes', _$hasUnseenEpisodes,
      key: r'has_unseen_episodes');

  @override
  final MappableFields<PodcastWithStatus> fields = const {
    #podcast: _f$podcast,
    #listenedEpisodes: _f$listenedEpisodes,
    #totalEpisodes: _f$totalEpisodes,
    #hasUnseenEpisodes: _f$hasUnseenEpisodes,
  };

  static PodcastWithStatus _instantiate(DecodingData data) {
    return PodcastWithStatus(
        podcast: data.dec(_f$podcast),
        listenedEpisodes: data.dec(_f$listenedEpisodes),
        totalEpisodes: data.dec(_f$totalEpisodes),
        hasUnseenEpisodes: data.dec(_f$hasUnseenEpisodes));
  }

  @override
  final Function instantiate = _instantiate;

  static PodcastWithStatus fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PodcastWithStatus>(map);
  }

  static PodcastWithStatus fromJson(String json) {
    return ensureInitialized().decodeJson<PodcastWithStatus>(json);
  }
}

mixin PodcastWithStatusMappable {
  String toJson() {
    return PodcastWithStatusMapper.ensureInitialized()
        .encodeJson<PodcastWithStatus>(this as PodcastWithStatus);
  }

  Map<String, dynamic> toMap() {
    return PodcastWithStatusMapper.ensureInitialized()
        .encodeMap<PodcastWithStatus>(this as PodcastWithStatus);
  }

  PodcastWithStatusCopyWith<PodcastWithStatus, PodcastWithStatus,
          PodcastWithStatus>
      get copyWith =>
          _PodcastWithStatusCopyWithImpl<PodcastWithStatus, PodcastWithStatus>(
              this as PodcastWithStatus, $identity, $identity);
  @override
  String toString() {
    return PodcastWithStatusMapper.ensureInitialized()
        .stringifyValue(this as PodcastWithStatus);
  }

  @override
  bool operator ==(Object other) {
    return PodcastWithStatusMapper.ensureInitialized()
        .equalsValue(this as PodcastWithStatus, other);
  }

  @override
  int get hashCode {
    return PodcastWithStatusMapper.ensureInitialized()
        .hashValue(this as PodcastWithStatus);
  }
}

extension PodcastWithStatusValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PodcastWithStatus, $Out> {
  PodcastWithStatusCopyWith<$R, PodcastWithStatus, $Out>
      get $asPodcastWithStatus => $base
          .as((v, t, t2) => _PodcastWithStatusCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class PodcastWithStatusCopyWith<$R, $In extends PodcastWithStatus,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {PodcastSearch? podcast,
      int? listenedEpisodes,
      int? totalEpisodes,
      bool? hasUnseenEpisodes});
  PodcastWithStatusCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _PodcastWithStatusCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PodcastWithStatus, $Out>
    implements PodcastWithStatusCopyWith<$R, PodcastWithStatus, $Out> {
  _PodcastWithStatusCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PodcastWithStatus> $mapper =
      PodcastWithStatusMapper.ensureInitialized();
  @override
  $R call(
          {PodcastSearch? podcast,
          int? listenedEpisodes,
          int? totalEpisodes,
          bool? hasUnseenEpisodes}) =>
      $apply(FieldCopyWithData({
        if (podcast != null) #podcast: podcast,
        if (listenedEpisodes != null) #listenedEpisodes: listenedEpisodes,
        if (totalEpisodes != null) #totalEpisodes: totalEpisodes,
        if (hasUnseenEpisodes != null) #hasUnseenEpisodes: hasUnseenEpisodes
      }));
  @override
  PodcastWithStatus $make(CopyWithData data) => PodcastWithStatus(
      podcast: data.get(#podcast, or: $value.podcast),
      listenedEpisodes:
          data.get(#listenedEpisodes, or: $value.listenedEpisodes),
      totalEpisodes: data.get(#totalEpisodes, or: $value.totalEpisodes),
      hasUnseenEpisodes:
          data.get(#hasUnseenEpisodes, or: $value.hasUnseenEpisodes));

  @override
  PodcastWithStatusCopyWith<$R2, PodcastWithStatus, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _PodcastWithStatusCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
