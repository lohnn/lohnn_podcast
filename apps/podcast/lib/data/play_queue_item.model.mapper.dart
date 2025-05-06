// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'play_queue_item.model.dart';

class PlayQueueItemMapper extends ClassMapperBase<PlayQueueItem> {
  PlayQueueItemMapper._();

  static PlayQueueItemMapper? _instance;
  static PlayQueueItemMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PlayQueueItemMapper._());
      EpisodeImplMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'PlayQueueItem';

  static EpisodeImpl _$episode(PlayQueueItem v) => v.episode;
  static const Field<PlayQueueItem, EpisodeImpl> _f$episode =
      Field('episode', _$episode);
  static int _$queueOrder(PlayQueueItem v) => v.queueOrder;
  static const Field<PlayQueueItem, int> _f$queueOrder =
      Field('queueOrder', _$queueOrder);

  @override
  final MappableFields<PlayQueueItem> fields = const {
    #episode: _f$episode,
    #queueOrder: _f$queueOrder,
  };

  static PlayQueueItem _instantiate(DecodingData data) {
    return PlayQueueItem(
        episode: data.dec(_f$episode), queueOrder: data.dec(_f$queueOrder));
  }

  @override
  final Function instantiate = _instantiate;

  static PlayQueueItem fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PlayQueueItem>(map);
  }

  static PlayQueueItem fromJson(String json) {
    return ensureInitialized().decodeJson<PlayQueueItem>(json);
  }
}

mixin PlayQueueItemMappable {
  String toJson() {
    return PlayQueueItemMapper.ensureInitialized()
        .encodeJson<PlayQueueItem>(this as PlayQueueItem);
  }

  Map<String, dynamic> toMap() {
    return PlayQueueItemMapper.ensureInitialized()
        .encodeMap<PlayQueueItem>(this as PlayQueueItem);
  }

  PlayQueueItemCopyWith<PlayQueueItem, PlayQueueItem, PlayQueueItem>
      get copyWith => _PlayQueueItemCopyWithImpl<PlayQueueItem, PlayQueueItem>(
          this as PlayQueueItem, $identity, $identity);
  @override
  String toString() {
    return PlayQueueItemMapper.ensureInitialized()
        .stringifyValue(this as PlayQueueItem);
  }

  @override
  bool operator ==(Object other) {
    return PlayQueueItemMapper.ensureInitialized()
        .equalsValue(this as PlayQueueItem, other);
  }

  @override
  int get hashCode {
    return PlayQueueItemMapper.ensureInitialized()
        .hashValue(this as PlayQueueItem);
  }
}

extension PlayQueueItemValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PlayQueueItem, $Out> {
  PlayQueueItemCopyWith<$R, PlayQueueItem, $Out> get $asPlayQueueItem =>
      $base.as((v, t, t2) => _PlayQueueItemCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class PlayQueueItemCopyWith<$R, $In extends PlayQueueItem, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  EpisodeImplCopyWith<$R, EpisodeImpl, EpisodeImpl> get episode;
  $R call({EpisodeImpl? episode, int? queueOrder});
  PlayQueueItemCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _PlayQueueItemCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PlayQueueItem, $Out>
    implements PlayQueueItemCopyWith<$R, PlayQueueItem, $Out> {
  _PlayQueueItemCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PlayQueueItem> $mapper =
      PlayQueueItemMapper.ensureInitialized();
  @override
  EpisodeImplCopyWith<$R, EpisodeImpl, EpisodeImpl> get episode =>
      $value.episode.copyWith.$chain((v) => call(episode: v));
  @override
  $R call({EpisodeImpl? episode, int? queueOrder}) => $apply(FieldCopyWithData({
        if (episode != null) #episode: episode,
        if (queueOrder != null) #queueOrder: queueOrder
      }));
  @override
  PlayQueueItem $make(CopyWithData data) => PlayQueueItem(
      episode: data.get(#episode, or: $value.episode),
      queueOrder: data.get(#queueOrder, or: $value.queueOrder));

  @override
  PlayQueueItemCopyWith<$R2, PlayQueueItem, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _PlayQueueItemCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
